<template>
  <div class="ai-overlay" role="dialog" aria-modal="true" @click.self="close">
    <div class="wrap">
      <button class="close" aria-label="关闭" @click="close">×</button>
      <div class="topbar">
        <h1 class="title">有什么我能帮助你的吗?</h1>
        <div class="modes">
          <button :class="['mode', { on: mode==='fast' }]" @click="mode='fast'">极速</button>
          <button :class="['mode', { on: mode==='think' }]" @click="mode='think'">思考</button>
          <span v-if="paused" class="paused-tag">已暂停</span>
        </div>
      </div>

      <div class="chat" ref="chatPane">
        <template v-for="(m,i) in messages" :key="i">
          <div v-if="m.role==='assistant'" class="doc-card animated-in">
            <div class="doc-head">已完成思考</div>
            <div class="doc-body">{{ m.text }}</div>
          </div>
          <div v-else class="msg user"><div class="bubble">{{ m.text }}</div></div>
        </template>
        <div v-if="isTyping" class="doc-card thinking heat-pulse">
          <div class="doc-head">{{ isStreaming ? '深度思考中' : (paused ? '已暂停' : '思考中') }}</div>
          <div class="doc-body thinking-body">{{ thinkingText || '……' }}</div>
        </div>
      </div>

      <div class="chips">
        <button class="chip" v-for="q in quicks" :key="q" @click="use(q)">{{ q }}</button>
      </div>

      <div class="input-wrap">
        <button class="icon-btn" aria-label="附件" title="附件">
          <svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor"><path d="M16.5 6.5v9a4.5 4.5 0 1 1-9 0v-10A3.5 3.5 0 0 1 11 2h6" fill="none" stroke="currentColor" stroke-width="2"/></svg>
        </button>
        <input v-model="draft" class="input" placeholder="发消息或输入 / 选择技能" @keyup.enter="send" />
        <div class="right">
          <button v-if="isStreaming" class="icon-btn" aria-label="暂停" title="暂停" @click="pause">
            <svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor"><rect x="6" y="4" width="4" height="16" rx="1"/><rect x="14" y="4" width="4" height="16" rx="1"/></svg>
          </button>
          <button class="icon-btn" aria-label="清空" title="清空" @click="clear" v-if="draft || messages.length">
            <svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor"><path d="M3 6h18M8 6l1-2h6l1 2M6 6l1 14h10l1-14" fill="none" stroke="currentColor" stroke-width="2"/></svg>
          </button>
          <button class="icon-btn" aria-label="更多" title="更多">
            <svg viewBox="0 0 24 24" width="18" height="18" fill="currentColor"><circle cx="12" cy="5" r="1.5"/><circle cx="12" cy="12" r="1.5"/><circle cx="12" cy="19" r="1.5"/></svg>
          </button>
          <button class="send" @click="send" aria-label="发送">发 送</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, nextTick, onMounted, onBeforeUnmount } from 'vue'

const emit = defineEmits<{ (e:'close'): void }>()
function close(){ abort(); emit('close') }

interface Message { role:'user'|'assistant'; text:string }

const draft = ref('')
const messages = ref<Message[]>([])
const isTyping = ref(false)
const mode = ref<'fast'|'think'>('think')
const chatPane = ref<HTMLElement>()
const paused = ref(false)
const isStreaming = ref(false)
let es: EventSource | null = null
const thinkingText = ref('')
const endedByPause = ref(false)

const pending = ref('')
let inThink = false
let closedThink = false
const finalMsgIndex = ref<number | null>(null)

const quicks = ['图像生成', '帮我写作', '深入探究', '编程', '翻译', '更多']

function clear(){ draft.value=''; messages.value = [] }
function use(q:string){ draft.value = q; send() }
function scrollBottom(){ const el = chatPane.value; if (el) el.scrollTop = el.scrollHeight }
function onKey(e: KeyboardEvent){ if (e.key === 'Escape') close() }

function abort(keepThinking=false){
  if (es){ try { es.close() } catch {}
  }
  es = null; isStreaming.value = false; if (!keepThinking) isTyping.value = false
}

function pause(){ paused.value = true; endedByPause.value = true; abort(true) }

function ensureFinalMsg(){
  if (finalMsgIndex.value === null){
    messages.value.push({ role:'assistant', text: '' })
    finalMsgIndex.value = messages.value.length - 1
  }
}

function processPending(){
  while (pending.value.length){
    if (!closedThink){
      if (!inThink){
        const s = pending.value.indexOf('<think>')
        if (s !== -1){
          pending.value = pending.value.slice(s + 7)
          inThink = true
          continue
        } else {
          break
        }
      } else {
        const e = pending.value.indexOf('</think>')
        if (e !== -1){
          thinkingText.value += pending.value.slice(0, e)
          pending.value = pending.value.slice(e + 8)
          inThink = false
          closedThink = true
          ensureFinalMsg()
          continue
        } else {
          thinkingText.value += pending.value
          pending.value = ''
          break
        }
      }
    } else {
      ensureFinalMsg()
      messages.value[finalMsgIndex.value!].text += pending.value
      pending.value = ''
      break
    }
  }
}

async function send(){
  const content = draft.value.trim(); if(!content) return
  pending.value=''; inThink=false; closedThink=false; finalMsgIndex.value=null
  paused.value = false; endedByPause.value = false
  messages.value.push({ role:'user', text: content })
  draft.value = ''
  await nextTick(); scrollBottom()
  isTyping.value = true
  thinkingText.value = ''

  const prompt = mode.value==='fast' ? `[快速模式] ${content}` : content
  const url = `/api/ai/chat?prompt=${encodeURIComponent(prompt)}`
  try{
    es = new EventSource(url)
    isStreaming.value = true
    es.onmessage = async (e) => {
      if (!e?.data) return
      pending.value += e.data
      processPending()
      await nextTick(); scrollBottom()
    }
    es.onerror = async () => {
      const pausedNow = endedByPause.value
      endedByPause.value = false
      abort(!pausedNow)
      if (!pausedNow) {
        isTyping.value = false
        await nextTick(); scrollBottom()
      }
    }
  }catch{
    abort()
  }
}

onMounted(()=> window.addEventListener('keydown', onKey))
onBeforeUnmount(()=> { window.removeEventListener('keydown', onKey); abort() })
</script>

<style scoped>
.ai-overlay{ position:fixed; inset:0; background:radial-gradient(800px 400px at 100% 0%, rgba(249,115,22,.08), transparent), radial-gradient(600px 300px at 100% 100%, rgba(220,38,38,.06), transparent); z-index:1200 }
.wrap{ position:fixed; top:0; right:0; height:100vh; width:min(520px, 92vw); background:#fff; border-left:1px solid #ffd7c2; box-shadow:-14px 0 38px rgba(249,115,22,.15); padding:12px; display:grid; grid-template-rows:auto 1fr auto auto; gap:12px; animation: slideIn .26s ease-out both }
.close{ position:absolute; top:8px; right:8px; border:0; background:linear-gradient(135deg, #dc2626, #f97316); color:#fff; width:32px; height:32px; border-radius:8px; cursor:pointer; display:grid; place-items:center; font-size:18px; line-height:1; box-shadow:0 6px 18px rgba(249,115,22,.35) }
.close:hover{ filter:brightness(1.05) }
.topbar{ text-align:center }
.title{ margin:0 0 10px; font-weight:900; letter-spacing:.5px; background:linear-gradient(135deg, #1f2937, #111827); -webkit-background-clip:text; background-clip:text; color:transparent }
.modes{ display:inline-flex; gap:8px; align-items:center }
.mode{ padding:6px 10px; border-radius:999px; border:1px solid #ffe1cf; background:#fff; color:#9a3412; cursor:pointer; font-size:12px; transition:.15s ease; box-shadow:0 2px 8px rgba(249,115,22,.08) }
.mode:hover{ transform:translateY(-1px) }
.mode.on{ background:linear-gradient(135deg, #dc2626, #f97316); color:#fff; border-color:transparent; box-shadow:0 8px 20px rgba(249,115,22,.35) }
.paused-tag{ margin-left:8px; font-size:12px; color:#ef4444 }

.chat{ overflow:auto; padding:2px; scrollbar-width:thin }
.chat::-webkit-scrollbar{ width:8px }
.chat::-webkit-scrollbar-thumb{ background:linear-gradient(#fecaca,#fed7aa); border-radius:999px }

.doc-card{ background:#fff; border:1px solid #ffe1cf; border-radius:14px; box-shadow:0 8px 26px rgba(0,0,0,.06); padding:10px 12px; margin:10px 0 }
.doc-card.thinking{ background:rgba(255,245,235,.85); border:1px dashed #fdba74; backdrop-filter: blur(2px) }
.doc-head{ font-size:13px; color:#ea580c; margin-bottom:8px }
.doc-body{ white-space:pre-wrap; line-height:1.8; color:#111827 }
.thinking-body{ opacity:.9 }

.msg{ display:flex; margin:8px 0 }
.msg.user{ justify-content:flex-end }
.bubble{ max-width:60%; padding:10px 12px; border-radius:12px; background:linear-gradient(135deg, #dc2626, #f97316); color:#fff; box-shadow:0 4px 14px rgba(249,115,22,.25) }

.chips{ display:flex; gap:10px; justify-content:center; flex-wrap:wrap }
.chip{ padding:8px 12px; border:1px solid #ffe1cf; border-radius:999px; background:#fff; color:#7c2d12; cursor:pointer; font-size:12px; transition:.15s ease }
.chip:hover{ transform:translateY(-1px); box-shadow:0 8px 20px rgba(249,115,22,.18) }

.input-wrap{ position:sticky; bottom:0; display:flex; align-items:center; gap:10px; border:1px solid #ffe1cf; border-radius:14px; padding:12px 12px 12px 10px; box-shadow:0 12px 30px rgba(249,115,22,.12); background:#fff }
.input{ flex:1; border:0; outline:0; font-size:14px }
.icon-btn{ border:0; background:#fff; color:#9a3412; width:34px; height:34px; border-radius:8px; display:grid; place-items:center; cursor:pointer; transition:.12s ease }
.icon-btn:hover{ background:#fff7ed }
.right{ display:flex; align-items:center; gap:8px }
.send{ padding:8px 14px; border-radius:10px; background:linear-gradient(135deg, #f97316, #fb923c); color:#111827; border:0; cursor:pointer; font-weight:700; box-shadow:0 8px 22px rgba(249,115,22,.28) }
.send:hover{ filter:brightness(1.03) }

.animated-in{ animation: fadeUp .2s ease-out both }
.heat-pulse{ animation: heat 1.6s ease-in-out infinite }

@keyframes slideIn{ from{ transform:translateX(24px); opacity:0 } to{ transform:translateX(0); opacity:1 } }
@keyframes fadeUp{ from{ transform:translateY(6px); opacity:0 } to{ transform:translateY(0); opacity:1 } }
@keyframes heat{ 0%,100%{ box-shadow:0 6px 18px rgba(249,115,22,.18) } 50%{ box-shadow:0 10px 26px rgba(239,68,68,.25) } }

.typing{ display:flex; gap:6px; align-items:center }
.dot{ width:6px; height:6px; border-radius:50%; background:#fdba74; display:inline-block; animation: blink 1.2s infinite ease-in-out }
.dot:nth-child(2){ animation-delay: .15s }
.dot:nth-child(3){ animation-delay: .3s }
@keyframes blink{ 0%,80%,100%{ opacity:.2 } 40%{ opacity:1 } }
</style> 