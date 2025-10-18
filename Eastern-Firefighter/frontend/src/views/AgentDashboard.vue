<template>
  <div class="agent-dashboard">
    <div class="header">
      <h1>智能体控制台</h1>
      <div class="status-indicator">
        <span :class="['status-dot', agentStatus]"></span>
        <span>{{ agentStatusText }}</span>
      </div>
    </div>

    <div class="main-content">
      <!-- 任务创建区域 -->
      <div class="task-creator">
        <h2>创建新任务</h2>
        <div class="form-group">
          <label for="goal">任务目标:</label>
          <textarea 
            id="goal"
            v-model="newTask.goal" 
            placeholder="描述你想要智能体完成的任务..."
            rows="3"
          ></textarea>
        </div>
        <div class="form-group">
          <label for="context">上下文信息 (JSON格式):</label>
          <textarea 
            id="context"
            v-model="newTask.context" 
            placeholder='{"key": "value"}'
            rows="2"
          ></textarea>
        </div>
        <button @click="createTask" :disabled="!newTask.goal.trim()" class="create-btn">
          创建任务
        </button>
      </div>

      <!-- 活跃任务列表 -->
      <div class="tasks-section">
        <h2>活跃任务</h2>
        <div v-if="activeTasks.length === 0" class="empty-state">
          暂无活跃任务
        </div>
        <div v-else class="tasks-list">
          <div 
            v-for="task in activeTasks" 
            :key="task.taskId" 
            class="task-card"
            :class="task.status.toLowerCase()"
          >
            <div class="task-header">
              <h3>{{ task.goal }}</h3>
              <div class="task-status">
                <span :class="['status-badge', task.status.toLowerCase()]">
                  {{ getStatusText(task.status) }}
                </span>
                <div class="task-actions">
                  <button 
                    v-if="task.status === 'EXECUTING'" 
                    @click="pauseTask(task.taskId)"
                    class="action-btn pause"
                  >
                    暂停
                  </button>
                  <button 
                    v-if="task.status === 'PAUSED'" 
                    @click="resumeTask(task.taskId)"
                    class="action-btn resume"
                  >
                    恢复
                  </button>
                  <button @click="viewTaskDetails(task)" class="action-btn details">
                    详情
                  </button>
                </div>
              </div>
            </div>
            
            <div class="task-progress">
              <div class="progress-bar">
                <div 
                  class="progress-fill" 
                  :style="{ width: getProgressWidth(task) + '%' }"
                ></div>
              </div>
              <span class="progress-text">{{ getProgressText(task) }}</span>
            </div>

            <div v-if="task.actions && task.actions.length > 0" class="task-actions-list">
              <div 
                v-for="action in task.actions" 
                :key="action.actionId"
                class="action-item"
                :class="action.status.toLowerCase()"
              >
                <span class="action-name">{{ action.toolName }}</span>
                <span class="action-status">{{ getActionStatusText(action.status) }}</span>
                <div v-if="action.result" class="action-result">
                  {{ action.result.substring(0, 100) }}{{ action.result.length > 100 ? '...' : '' }}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 记忆管理 -->
      <div class="memory-section">
        <h2>记忆管理</h2>
        <div class="memory-search">
          <input 
            v-model="memoryQuery" 
            placeholder="搜索记忆..."
            @keyup.enter="searchMemory"
          />
          <button @click="searchMemory">搜索</button>
        </div>
        
        <div v-if="memories.length > 0" class="memories-list">
          <div 
            v-for="memory in memories" 
            :key="memory.memoryId"
            class="memory-item"
          >
            <div class="memory-header">
              <span class="memory-type">{{ memory.type }}</span>
              <span class="memory-time">{{ formatTime(memory.createdAt) }}</span>
            </div>
            <div class="memory-content">{{ memory.content }}</div>
          </div>
        </div>
      </div>
    </div>

    <!-- 任务详情模态框 -->
    <div v-if="selectedTask" class="modal-overlay" @click="closeTaskDetails">
      <div class="modal-content" @click.stop>
        <div class="modal-header">
          <h3>任务详情</h3>
          <button @click="closeTaskDetails" class="close-btn">×</button>
        </div>
        <div class="modal-body">
          <div class="task-info">
            <p><strong>任务ID:</strong> {{ selectedTask.taskId }}</p>
            <p><strong>目标:</strong> {{ selectedTask.goal }}</p>
            <p><strong>状态:</strong> {{ getStatusText(selectedTask.status) }}</p>
            <p><strong>创建时间:</strong> {{ formatTime(selectedTask.createdAt) }}</p>
            <p><strong>更新时间:</strong> {{ formatTime(selectedTask.updatedAt) }}</p>
          </div>
          
          <div v-if="selectedTask.result" class="task-result">
            <h4>执行结果:</h4>
            <pre>{{ selectedTask.result }}</pre>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

// 响应式数据
const agentStatus = ref('unknown')
const agentStatusText = ref('未知')
const activeTasks = ref([])
const memories = ref([])
const newTask = ref({
  goal: '',
  context: ''
})
const memoryQuery = ref('')
const selectedTask = ref(null)

// 定时器
let statusTimer: number | null = null
let tasksTimer: number | null = null

// 生命周期
onMounted(() => {
  checkAgentStatus()
  loadActiveTasks()
  
  // 设置定时器
  statusTimer = setInterval(checkAgentStatus, 5000)
  tasksTimer = setInterval(loadActiveTasks, 2000)
})

onUnmounted(() => {
  if (statusTimer) clearInterval(statusTimer)
  if (tasksTimer) clearInterval(tasksTimer)
})

// 检查智能体状态
async function checkAgentStatus() {
  try {
    const response = await fetch('/api/agent/health')
    const data = await response.json()
    agentStatus.value = data.status === 'UP' ? 'online' : 'offline'
    agentStatusText.value = data.status === 'UP' ? '在线' : '离线'
  } catch (error) {
    agentStatus.value = 'offline'
    agentStatusText.value = '离线'
  }
}

// 加载活跃任务
async function loadActiveTasks() {
  try {
    const response = await fetch('/api/agent/tasks')
    const data = await response.json()
    activeTasks.value = Object.values(data)
  } catch (error) {
    console.error('加载任务失败:', error)
  }
}

// 创建任务
async function createTask() {
  try {
    const context = newTask.value.context.trim() ? JSON.parse(newTask.value.context) : {}
    
    const response = await fetch('/api/agent/tasks', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        goal: newTask.value.goal,
        context: context
      })
    })
    
    if (response.ok) {
      const result = await response.json()
      alert('任务创建成功: ' + result.taskId)
      newTask.value.goal = ''
      newTask.value.context = ''
      loadActiveTasks()
    } else {
      const error = await response.json()
      alert('创建任务失败: ' + error.error)
    }
  } catch (error) {
    alert('创建任务失败: ' + error.message)
  }
}

// 暂停任务
async function pauseTask(taskId: string) {
  try {
    const response = await fetch(`/api/agent/tasks/${taskId}/pause`, {
      method: 'POST'
    })
    if (response.ok) {
      loadActiveTasks()
    }
  } catch (error) {
    console.error('暂停任务失败:', error)
  }
}

// 恢复任务
async function resumeTask(taskId: string) {
  try {
    const response = await fetch(`/api/agent/tasks/${taskId}/resume`, {
      method: 'POST'
    })
    if (response.ok) {
      loadActiveTasks()
    }
  } catch (error) {
    console.error('恢复任务失败:', error)
  }
}

// 查看任务详情
async function viewTaskDetails(task: any) {
  try {
    const response = await fetch(`/api/agent/tasks/${task.taskId}`)
    if (response.ok) {
      selectedTask.value = await response.json()
    }
  } catch (error) {
    console.error('获取任务详情失败:', error)
  }
}

// 关闭任务详情
function closeTaskDetails() {
  selectedTask.value = null
}

// 搜索记忆
async function searchMemory() {
  if (!memoryQuery.value.trim()) return
  
  try {
    const response = await fetch(`/api/agent/memory/search?query=${encodeURIComponent(memoryQuery.value)}&limit=10`)
    if (response.ok) {
      memories.value = await response.json()
    }
  } catch (error) {
    console.error('搜索记忆失败:', error)
  }
}

// 工具函数
function getStatusText(status: string) {
  const statusMap: Record<string, string> = {
    'PLANNING': '规划中',
    'EXECUTING': '执行中',
    'PAUSED': '已暂停',
    'COMPLETED': '已完成',
    'FAILED': '失败'
  }
  return statusMap[status] || status
}

function getActionStatusText(status: string) {
  const statusMap: Record<string, string> = {
    'PENDING': '等待中',
    'EXECUTING': '执行中',
    'COMPLETED': '已完成',
    'FAILED': '失败'
  }
  return statusMap[status] || status
}

function getProgressWidth(task: any) {
  if (!task.actions || task.actions.length === 0) return 0
  
  const completedActions = task.actions.filter((action: any) => 
    action.status === 'COMPLETED'
  ).length
  
  return (completedActions / task.actions.length) * 100
}

function getProgressText(task: any) {
  if (!task.actions || task.actions.length === 0) return '0/0'
  
  const completedActions = task.actions.filter((action: any) => 
    action.status === 'COMPLETED'
  ).length
  
  return `${completedActions}/${task.actions.length}`
}

function formatTime(timeStr: string) {
  return new Date(timeStr).toLocaleString('zh-CN')
}
</script>

<style scoped>
.agent-dashboard {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
  padding-bottom: 20px;
  border-bottom: 2px solid #e5e7eb;
}

.header h1 {
  color: #1f2937;
  margin: 0;
}

.status-indicator {
  display: flex;
  align-items: center;
  gap: 8px;
}

.status-dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
}

.status-dot.online {
  background-color: #10b981;
}

.status-dot.offline {
  background-color: #ef4444;
}

.status-dot.unknown {
  background-color: #6b7280;
}

.main-content {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 30px;
}

.task-creator {
  background: #f9fafb;
  padding: 20px;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
}

.task-creator h2 {
  margin-top: 0;
  color: #374151;
}

.form-group {
  margin-bottom: 16px;
}

.form-group label {
  display: block;
  margin-bottom: 6px;
  font-weight: 500;
  color: #374151;
}

.form-group textarea {
  width: 100%;
  padding: 12px;
  border: 1px solid #d1d5db;
  border-radius: 8px;
  font-size: 14px;
  resize: vertical;
}

.form-group textarea:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.create-btn {
  background: linear-gradient(135deg, #3b82f6, #1d4ed8);
  color: white;
  border: none;
  padding: 12px 24px;
  border-radius: 8px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.create-btn:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
}

.create-btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.tasks-section, .memory-section {
  background: white;
  padding: 20px;
  border-radius: 12px;
  border: 1px solid #e5e7eb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.tasks-section h2, .memory-section h2 {
  margin-top: 0;
  color: #374151;
}

.empty-state {
  text-align: center;
  color: #6b7280;
  padding: 40px;
}

.tasks-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.task-card {
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  padding: 16px;
  transition: all 0.2s;
}

.task-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.task-card.executing {
  border-left: 4px solid #3b82f6;
}

.task-card.paused {
  border-left: 4px solid #f59e0b;
}

.task-card.completed {
  border-left: 4px solid #10b981;
}

.task-card.failed {
  border-left: 4px solid #ef4444;
}

.task-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 12px;
}

.task-header h3 {
  margin: 0;
  font-size: 16px;
  color: #1f2937;
  flex: 1;
}

.task-status {
  display: flex;
  align-items: center;
  gap: 12px;
}

.status-badge {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: 500;
}

.status-badge.executing {
  background: #dbeafe;
  color: #1e40af;
}

.status-badge.paused {
  background: #fef3c7;
  color: #92400e;
}

.status-badge.completed {
  background: #d1fae5;
  color: #065f46;
}

.status-badge.failed {
  background: #fee2e2;
  color: #991b1b;
}

.task-actions {
  display: flex;
  gap: 8px;
}

.action-btn {
  padding: 6px 12px;
  border: 1px solid #d1d5db;
  border-radius: 4px;
  background: white;
  font-size: 12px;
  cursor: pointer;
  transition: all 0.2s;
}

.action-btn:hover {
  background: #f9fafb;
}

.action-btn.pause {
  color: #f59e0b;
  border-color: #f59e0b;
}

.action-btn.resume {
  color: #10b981;
  border-color: #10b981;
}

.action-btn.details {
  color: #3b82f6;
  border-color: #3b82f6;
}

.task-progress {
  margin-bottom: 12px;
}

.progress-bar {
  width: 100%;
  height: 6px;
  background: #e5e7eb;
  border-radius: 3px;
  overflow: hidden;
  margin-bottom: 4px;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #3b82f6, #1d4ed8);
  transition: width 0.3s ease;
}

.progress-text {
  font-size: 12px;
  color: #6b7280;
}

.task-actions-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.action-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px;
  background: #f9fafb;
  border-radius: 4px;
  font-size: 12px;
}

.action-item.completed {
  background: #f0fdf4;
}

.action-item.failed {
  background: #fef2f2;
}

.action-name {
  font-weight: 500;
  color: #374151;
  min-width: 80px;
}

.action-status {
  color: #6b7280;
  min-width: 60px;
}

.action-result {
  color: #6b7280;
  flex: 1;
  font-style: italic;
}

.memory-search {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
}

.memory-search input {
  flex: 1;
  padding: 8px 12px;
  border: 1px solid #d1d5db;
  border-radius: 6px;
}

.memory-search button {
  padding: 8px 16px;
  background: #3b82f6;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
}

.memories-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.memory-item {
  border: 1px solid #e5e7eb;
  border-radius: 6px;
  padding: 12px;
}

.memory-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
}

.memory-type {
  font-size: 12px;
  padding: 2px 6px;
  background: #e5e7eb;
  border-radius: 3px;
  color: #374151;
}

.memory-time {
  font-size: 12px;
  color: #6b7280;
}

.memory-content {
  color: #374151;
  font-size: 14px;
}

.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.modal-content {
  background: white;
  border-radius: 12px;
  max-width: 600px;
  width: 90%;
  max-height: 80vh;
  overflow: hidden;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
  border-bottom: 1px solid #e5e7eb;
}

.modal-header h3 {
  margin: 0;
  color: #1f2937;
}

.close-btn {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #6b7280;
}

.modal-body {
  padding: 20px;
  overflow-y: auto;
}

.task-info p {
  margin-bottom: 8px;
  color: #374151;
}

.task-result {
  margin-top: 20px;
}

.task-result h4 {
  margin-bottom: 8px;
  color: #1f2937;
}

.task-result pre {
  background: #f9fafb;
  padding: 12px;
  border-radius: 6px;
  font-size: 12px;
  color: #374151;
  overflow-x: auto;
}

@media (max-width: 768px) {
  .main-content {
    grid-template-columns: 1fr;
  }
  
  .task-header {
    flex-direction: column;
    gap: 8px;
  }
  
  .task-status {
    flex-direction: column;
    align-items: flex-start;
  }
}
</style>

