<template>
	<div class="zoom-root" @wheel.passive="onWheel">
		<div
			class="zoom-content"
			:style="{
				transform: `translate(${translateX}px, ${translateY}px) scale(${scale})`,
				transformOrigin: '0 0'
			}"
			@pointerdown="onPointerDown"
			@pointermove="onPointerMove"
			@pointerup="onPointerUp"
			@pointercancel="onPointerUp"
			@pointerleave="onPointerUp"
		>
			<slot />
		</div>
		<div class="zoom-controls">
			<button class="zbtn" title="缩小 (-)" @click="applyStep(-zoomStep)">−</button>
			<span class="zval">{{ Math.round(scale*100) }}%</span>
			<button class="zbtn" title="放大 (+)" @click="applyStep(zoomStep)">＋</button>
			<button class="zbtn" title="重置 (100%)" @click="reset">重置</button>
		</div>
	</div>
</template>

<script setup lang="ts">
import { ref, onMounted, onBeforeUnmount } from 'vue'

interface Props {
	min?: number
	max?: number
	step?: number
	initial?: number
}

const props = withDefaults(defineProps<Props>(), {
	min: 0.5,
	max: 2,
	step: 0.1,
	initial: 1
})

const scale = ref(props.initial)
const zoomStep = props.step
const translateX = ref(0)
const translateY = ref(0)
const isPanning = ref(false)
const spacePressed = ref(false)
let lastX = 0, lastY = 0

function clamp(v: number, min: number, max: number){ return Math.max(min, Math.min(max, v)) }

function setScaleAt(pointX: number, pointY: number, next: number){
	const prev = scale.value
	next = clamp(next, props.min, props.max)
	// 以当前指针位置为缩放中心，修正位移，保证视觉对齐
	const factor = next / prev
	translateX.value = pointX - (pointX - translateX.value) * factor
	translateY.value = pointY - (pointY - translateY.value) * factor
	scale.value = next
}

function onWheel(e: WheelEvent){
	if (!e.ctrlKey) return // 仅 Ctrl+滚轮触发缩放，避免干扰正常滚动
	e.preventDefault()
	const rect = (e.currentTarget as HTMLElement).getBoundingClientRect()
	const x = e.clientX - rect.left
	const y = e.clientY - rect.top
	const delta = -Math.sign(e.deltaY) * zoomStep
	setScaleAt(x, y, scale.value + delta)
}

function onPointerDown(e: PointerEvent){
	// Space 按下或中键按下时进入平移模式
	if (spacePressed.value || e.button === 1){
		isPanning.value = true
		lastX = e.clientX
		lastY = e.clientY
		;(e.currentTarget as HTMLElement).setPointerCapture(e.pointerId)
	}
}

function onPointerMove(e: PointerEvent){
	if (!isPanning.value) return
	const dx = e.clientX - lastX
	const dy = e.clientY - lastY
	translateX.value += dx
	translateY.value += dy
	lastX = e.clientX
	lastY = e.clientY
}

function onPointerUp(e: PointerEvent){
	if (isPanning.value){
		isPanning.value = false
		try { (e.currentTarget as HTMLElement).releasePointerCapture(e.pointerId) } catch {}
	}
}

function applyStep(delta: number){
	setScaleAt(0, 0, scale.value + delta)
}

function reset(){
	scale.value = 1
	translateX.value = 0
	translateY.value = 0
}

function onKeydown(e: KeyboardEvent){ if (e.code === 'Space') spacePressed.value = true }
function onKeyup(e: KeyboardEvent){ if (e.code === 'Space') spacePressed.value = false }

onMounted(() => {
	window.addEventListener('keydown', onKeydown)
	window.addEventListener('keyup', onKeyup)
})

onBeforeUnmount(() => {
	window.removeEventListener('keydown', onKeydown)
	window.removeEventListener('keyup', onKeyup)
})
</script>

<style scoped>
.zoom-root{ position:relative; width:100%; height:100%; overflow:hidden }
.zoom-content{ will-change: transform; }
.zoom-controls{
	position:fixed; right:16px; bottom:16px; z-index:1000;
	display:flex; gap:8px; align-items:center; padding:6px 8px;
	background:#fff; border:1px solid #e5e7eb; border-radius:999px;
	box-shadow:0 8px 24px rgba(0,0,0,.12);
}
.zbtn{ padding:6px 10px; border:1px solid #e5e7eb; border-radius:8px; background:#fff; cursor:pointer; font-size:12px }
.zbtn:hover{ background:#f8fafc }
.zval{ font-weight:600; color:#334155; min-width:44px; text-align:center }

@media (prefers-color-scheme: dark){
	.zoom-controls{ background:#0f172a; border-color:#1f2937; box-shadow:0 8px 24px rgba(0,0,0,.45) }
	.zbtn{ background:#0f172a; border-color:#1f2937; color:#e5e7eb }
	.zbtn:hover{ background:#111827 }
	.zval{ color:#e5e7eb }
}
</style> 