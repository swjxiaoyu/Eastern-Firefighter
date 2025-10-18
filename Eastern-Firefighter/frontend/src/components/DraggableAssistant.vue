<template>
  <div
    ref="assistantButton"
    class="draggable-assistant"
    :class="{
      'is-dragging': isDragging,
      'is-hidden': isHidden,
      'is-expanded': isExpanded
    }"
    :style="buttonStyle"
    @mousedown="startDrag"
    @touchstart="startDrag"
    @click="handleClick"
  >
    <div class="assistant-content">
      <span class="icon">🤖</span>
      <span class="label" v-show="!isHidden">助手</span>
    </div>
    
    <!-- 展开状态时的额外内容 -->
    <div class="expanded-content" v-if="isExpanded">
      <div class="quick-actions">
        <button class="quick-btn" @click.stop="openChat">智能聊天</button>
        <button class="quick-btn" @click.stop="openHelp">帮助中心</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'

const emit = defineEmits<{
  (e: 'open'): void
}>()

// 响应式数据
const assistantButton = ref<HTMLElement>()
const isDragging = ref(false)
const isHidden = ref(false)
const isExpanded = ref(false)
const position = ref({ x: 0, y: 0 })
const dragStart = ref({ x: 0, y: 0 })
const startPosition = ref({ x: 0, y: 0 })
const hasMoved = ref(false) // 是否真正移动了
const justUnhidden = ref(false) // 是否刚刚从隐藏状态恢复

// 计算样式
const buttonStyle = computed(() => ({
  transform: `translate(${position.value.x}px, ${position.value.y}px)`,
  transition: isDragging.value ? 'none' : 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)'
}))

// 边界检测
const checkBoundaries = () => {
  if (!assistantButton.value) return
  
  const rect = assistantButton.value.getBoundingClientRect()
  const windowWidth = window.innerWidth
  const windowHeight = window.innerHeight
  
  // 检测是否接近边界
  const nearLeft = rect.left < 50
  const nearRight = rect.right > windowWidth - 50
  const nearTop = rect.top < 50
  const nearBottom = rect.bottom > windowHeight - 50
  
  // 如果接近边界，隐藏一半
  if (nearLeft || nearRight || nearTop || nearBottom) {
    isHidden.value = true
  } else {
    isHidden.value = false
  }
}

// 开始拖拽
const startDrag = (e: MouseEvent | TouchEvent) => {
  e.preventDefault()
  e.stopPropagation()
  
  isDragging.value = true
  isExpanded.value = false
  hasMoved.value = false // 重置移动状态
  
  const clientX = 'touches' in e ? e.touches[0].clientX : e.clientX
  const clientY = 'touches' in e ? e.touches[0].clientY : e.clientY
  
  dragStart.value = { x: clientX, y: clientY }
  startPosition.value = { x: position.value.x, y: position.value.y }
  
  // 添加事件监听器
  document.addEventListener('mousemove', handleDrag, { passive: false })
  document.addEventListener('mouseup', endDrag)
  document.addEventListener('touchmove', handleDrag, { passive: false })
  document.addEventListener('touchend', endDrag)
}

// 处理拖拽
const handleDrag = (e: MouseEvent | TouchEvent) => {
  if (!isDragging.value) return
  
  e.preventDefault()
  e.stopPropagation()
  
  const clientX = 'touches' in e ? e.touches[0].clientX : e.clientX
  const clientY = 'touches' in e ? e.touches[0].clientY : e.clientY
  
  const deltaX = clientX - dragStart.value.x
  const deltaY = clientY - dragStart.value.y
  
  // 检查是否真正移动了（超过5像素才算移动）
  const distance = Math.sqrt(deltaX * deltaX + deltaY * deltaY)
  if (distance > 5) {
    hasMoved.value = true
  }
  
  position.value = {
    x: startPosition.value.x + deltaX,
    y: startPosition.value.y + deltaY
  }
  
  // 实时检查边界
  checkBoundaries()
}

// 结束拖拽
const endDrag = () => {
  isDragging.value = false
  
  // 移除事件监听器
  document.removeEventListener('mousemove', handleDrag)
  document.removeEventListener('mouseup', endDrag)
  document.removeEventListener('touchmove', handleDrag)
  document.removeEventListener('touchend', endDrag)
  
  // 最终边界检查
  checkBoundaries()
  
  // 延迟重置移动状态，避免立即触发点击事件
  setTimeout(() => {
    hasMoved.value = false
  }, 100)
}

// 处理点击
const handleClick = (e: MouseEvent | TouchEvent) => {
  // 如果正在拖拽或已经移动过，不处理点击事件
  if (isDragging.value || hasMoved.value) {
    e.preventDefault()
    e.stopPropagation()
    return
  }
  
  e.preventDefault()
  e.stopPropagation()
  
  if (isHidden.value) {
    // 如果隐藏，点击展开按钮（不显示菜单）
    isHidden.value = false
    isExpanded.value = false // 确保不显示菜单
    justUnhidden.value = true // 标记刚刚从隐藏状态恢复
    // 延迟重置标记，避免立即触发聊天
    setTimeout(() => {
      justUnhidden.value = false
    }, 300)
  } else if (isExpanded.value) {
    // 如果已展开，点击收起
    isExpanded.value = false
  } else if (!justUnhidden.value) {
    // 只有在不是刚刚从隐藏状态恢复时才打开聊天
    openChat()
  }
}

// 打开聊天
const openChat = () => {
  isExpanded.value = false
  emit('open')
}

// 打开帮助中心
const openHelp = () => {
  isExpanded.value = false
  // 这里可以添加帮助中心的逻辑
  console.log('打开帮助中心')
}

// 初始化位置
const initPosition = () => {
  if (!assistantButton.value) return
  
  const windowWidth = window.innerWidth
  const windowHeight = window.innerHeight
  
  // 默认位置在右下角
  position.value = {
    x: windowWidth - 200, // 距离右边200px
    y: windowHeight - 100  // 距离底部100px
  }
}

// 监听窗口大小变化
const handleResize = () => {
  checkBoundaries()
}

onMounted(() => {
  initPosition()
  window.addEventListener('resize', handleResize)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', handleResize)
  // 清理事件监听器
  document.removeEventListener('mousemove', handleDrag)
  document.removeEventListener('mouseup', endDrag)
  document.removeEventListener('touchmove', handleDrag)
  document.removeEventListener('touchend', endDrag)
})
</script>

<style scoped>
.draggable-assistant {
  position: fixed;
  z-index: 1000;
  cursor: pointer;
  user-select: none;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.draggable-assistant.is-dragging {
  cursor: grabbing;
  transition: none;
}

.draggable-assistant.is-hidden {
  opacity: 0.5;
  transform: translateX(-50px) !important;
}

.draggable-assistant.is-expanded {
  z-index: 1001;
}

.assistant-content {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 16px;
  background: linear-gradient(135deg, #ef3a2d, #ff8f1f);
  color: #fff;
  border-radius: 999px;
  box-shadow: 0 6px 24px rgba(239, 58, 45, 0.35);
  font-weight: 700;
  letter-spacing: 0.5px;
  transition: all 0.3s ease;
  min-width: 60px;
  justify-content: center;
}

.draggable-assistant:hover .assistant-content {
  filter: brightness(1.05);
  box-shadow: 0 10px 28px rgba(239, 58, 45, 0.4);
  transform: scale(1.05);
}

.draggable-assistant.is-dragging .assistant-content {
  transform: scale(1.1);
  box-shadow: 0 12px 32px rgba(239, 58, 45, 0.5);
}

.assistant-content .icon {
  font-size: 18px;
  line-height: 1;
}

.assistant-content .label {
  font-size: 14px;
  white-space: nowrap;
}

.expanded-content {
  position: absolute;
  top: 100%;
  right: 0;
  margin-top: 8px;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
  border: 1px solid #f0f0f0;
  overflow: hidden;
  animation: expandIn 0.3s ease-out;
  min-width: 200px;
}

.quick-actions {
  padding: 12px;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.quick-btn {
  padding: 10px 16px;
  border: none;
  background: #f8fafc;
  color: #374151;
  border-radius: 12px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 600;
  transition: all 0.2s ease;
  text-align: left;
}

.quick-btn:hover {
  background: linear-gradient(135deg, #ef3a2d, #ff8f1f);
  color: #fff;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(239, 58, 45, 0.3);
}

@keyframes expandIn {
  from {
    opacity: 0;
    transform: translateY(-10px) scale(0.95);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

/* 移动端优化 */
@media (max-width: 768px) {
  .assistant-content {
    padding: 10px 14px;
    min-width: 50px;
  }
  
  .assistant-content .label {
    display: none;
  }
  
  .expanded-content {
    min-width: 180px;
  }
  
  .quick-btn {
    padding: 12px 16px;
    font-size: 15px;
  }
}

/* 触摸设备优化 */
@media (hover: none) and (pointer: coarse) {
  .draggable-assistant:hover .assistant-content {
    transform: none;
  }
  
  .draggable-assistant:active .assistant-content {
    transform: scale(1.05);
  }
}

/* 隐藏状态动画 */
.draggable-assistant.is-hidden .assistant-content {
  background: linear-gradient(135deg, rgba(239, 58, 45, 0.7), rgba(255, 143, 31, 0.7));
  backdrop-filter: blur(10px);
}

/* 拖拽时的视觉反馈 */
.draggable-assistant.is-dragging {
  filter: drop-shadow(0 8px 25px rgba(239, 58, 45, 0.4));
}

/* 确保在边界时按钮仍然可见 */
.draggable-assistant.is-hidden {
  pointer-events: auto;
}

.draggable-assistant.is-hidden .assistant-content {
  border: 2px solid rgba(255, 255, 255, 0.3);
}
</style>
