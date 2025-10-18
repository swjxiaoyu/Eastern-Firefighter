<template>
	<div class="fireman" ref="man" :style="style" @mousedown.self="start" @touchstart.self.prevent="startTouch" @click.stop="onClick" :title="'拖动我'">
		<div class="hat"></div>
		<div class="face"></div>
		<div class="body"></div>
		<div class="hose"></div>
		<div v-if="spraying" class="beam"></div>
		<div v-if="showMenu" class="menu" @click.stop>
			<button class="mi" @click="spray">灭火</button>
			<button class="mi" @click="promo">宣传页</button>
			<button class="mi" @click="toTop">顶部</button>
		</div>
	</div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { useRouter } from 'vue-router'
const router = useRouter()

const x = ref(24)
const y = ref(280)
const dragging = ref(false)
let dx = 0, dy = 0
let sx = 0, sy = 0

const style = computed(() => ({ transform:`translate(${x.value}px, ${y.value}px)` }))

function start(e: MouseEvent){ showMenu.value=false; dragging.value = true; dx = e.clientX - x.value; dy = e.clientY - y.value; sx = e.clientX; sy = e.clientY; window.addEventListener('mousemove', move); window.addEventListener('mouseup', end) }
function move(e: MouseEvent){ if(!dragging.value) return; setPos(e.clientX - dx, e.clientY - dy) }
function end(e?: MouseEvent){ const moved = e ? (Math.abs(e.clientX - sx) + Math.abs(e.clientY - sy) > 6) : true; dragging.value = false; window.removeEventListener('mousemove', move); window.removeEventListener('mouseup', end); if(!moved){ toggleMenu() } }

function startTouch(e: TouchEvent){ showMenu.value=false; dragging.value = true; const t = e.touches[0]; dx = t.clientX - x.value; dy = t.clientY - y.value; sx = t.clientX; sy = t.clientY; window.addEventListener('touchmove', moveTouch, { passive:false }); window.addEventListener('touchend', endTouch) }
function moveTouch(e: TouchEvent){ if(!dragging.value) return; const t = e.touches[0]; setPos(t.clientX - dx, t.clientY - dy) }
function endTouch(e: TouchEvent){ const t = e.changedTouches[0]; const moved = Math.abs(t.clientX - sx) + Math.abs(t.clientY - sy) > 6; dragging.value = false; window.removeEventListener('touchmove', moveTouch); window.removeEventListener('touchend', endTouch); if(!moved){ toggleMenu() } }

function onClick(){ /* 作为兜底：若未拖动则切换菜单 */ if(!dragging.value) toggleMenu() }

function setPos(nx:number, ny:number){
	const maxX = (window.innerWidth - 64)
	const maxY = (window.innerHeight - 120)
	x.value = Math.max(0, Math.min(nx, maxX))
	y.value = Math.max(60, Math.min(ny, maxY))
}

const spraying = ref(false)
const showMenu = ref(false)
let hideTimer: number | undefined
function toggleMenu(){ showMenu.value = !showMenu.value; resetHide() }
function resetHide(){ if(hideTimer) window.clearTimeout(hideTimer); hideTimer = window.setTimeout(()=> showMenu.value=false, 4000) as unknown as number }

function spray(){ showMenu.value=false; spraying.value = true; window.setTimeout(()=> spraying.value=false, 1400) }
function promo(){ showMenu.value=false; router.push('/articles') }
function toTop(){ showMenu.value=false; window.scrollTo({ top: 0, behavior: 'smooth' }) }

onMounted(() => { const timer = setInterval(()=>{ if(!dragging.value){ x.value += Math.sin(Date.now()/900)*0.2; } }, 30); onBeforeUnmount(()=>clearInterval(timer)) })
</script>

<style scoped>
.fireman{ position: fixed; top:0; left:0; z-index:1100; width:64px; height:96px; cursor:grab; user-select:none; }
.fireman:active{ cursor:grabbing }
.hat{ position:absolute; top:0; left:8px; width:48px; height:18px; border-radius:8px 8px 2px 2px; background:linear-gradient(135deg,#dc2626,#f97316); box-shadow:0 4px 10px rgba(249,115,22,.35) }
.face{ position:absolute; top:16px; left:16px; width:32px; height:28px; background:#ffe7cc; border-radius:6px; box-shadow: inset 0 -4px 0 rgba(0,0,0,.06) }
.body{ position:absolute; top:38px; left:8px; width:48px; height:46px; background:linear-gradient(135deg,#111827,#0f2a43); border-radius:8px; box-shadow:0 6px 16px rgba(0,0,0,.18) }
.hose{ position:absolute; top:54px; left:40px; width:36px; height:10px; background:linear-gradient(90deg,#93c5fd,#3b82f6); border-radius:8px; transform-origin:left center; animation:spray 2.2s ease-in-out infinite }
.beam{ position:absolute; top:58px; left:50px; width:0; height:8px; border-radius:6px; background:linear-gradient(90deg,rgba(147,197,253,.0), rgba(147,197,253,.9)); box-shadow:0 0 16px rgba(59,130,246,.55); animation:beam 1.3s ease forwards }
.menu{ position:absolute; left:70px; top:18px; display:flex; gap:6px; background:#fff; border:1px solid #e5e7eb; border-radius:10px; padding:6px 8px; box-shadow:var(--shadow) }
.mi{ border:0; background:#111827; color:#fff; padding:6px 8px; border-radius:8px; font-size:12px; cursor:pointer }
.mi:hover{ filter:brightness(1.05) }
@keyframes spray{ 0%,100%{ transform:rotate(0deg) scaleX(.8) } 50%{ transform:rotate(6deg) scaleX(1) } }
@keyframes beam{ 0%{ width:0; opacity:.6 } 70%{ width:120px; opacity:1 } 100%{ width:140px; opacity:.0 } }
</style> 