<template>
  <ZoomPane>
  <div class="article-admin">
    <div class="header">
      <h1>文章管理</h1>
      <router-link to="/admin/articles/create" class="btn btn-primary">新建文章</router-link>
    </div>

    <div class="filters">
      <input 
        v-model="filters.keyword" 
        placeholder="搜索标题或摘要..." 
        @keyup.enter="search"
        class="search-input"
      >
      <select v-model="filters.channel" @change="search" class="channel-select">
        <option value="">全部频道</option>
        <option value="safety">安全科普</option>
        <option value="news">新闻资讯</option>
        <option value="guide">使用指南</option>
      </select>
      <button @click="search" class="btn btn-secondary">搜索</button>
    </div>

    <div class="table-container">
      <table class="article-table">
        <thead>
          <tr>
            <th>标题</th>
            <th>频道</th>
            <th>状态</th>
            <th>发布时间</th>
            <th>更新时间</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="article in articles" :key="article.id">
            <td>
              <div class="article-title">
                <img v-if="article.coverUrl" :src="article.coverUrl" :alt="article.title" loading="lazy" decoding="async" width="120" height="80" class="cover-thumb" />
                <div>
                  <div class="title">{{ article.title }}</div>
                  <div class="summary">{{ article.summary }}</div>
                </div>
              </div>
            </td>
            <td>
              <span class="channel-tag">{{ getChannelName(article.channel) }}</span>
            </td>
            <td>
              <span :class="['status', article.status === 1 ? 'published' : 'draft']">
                {{ article.status === 1 ? '已发布' : '草稿' }}
              </span>
            </td>
            <td>{{ formatDate(article.publishedAt) }}</td>
            <td>{{ formatDate(article.updatedAt) }}</td>
            <td>
              <div class="actions">
                <router-link :to="`/admin/articles/${article.id}/edit`" class="btn btn-sm">编辑</router-link>
                <button 
                  v-if="article.status === 0" 
                  @click="publish(article.id)" 
                  class="btn btn-sm btn-success"
                >发布</button>
                <button 
                  v-if="article.status === 1" 
                  @click="unpublish(article.id)" 
                  class="btn btn-sm btn-warning"
                >取消发布</button>
                <button @click="deleteArticle(article.id)" class="btn btn-sm btn-danger">删除</button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div class="pagination" v-if="total > 0">
      <button 
        @click="changePage(page - 1)" 
        :disabled="page <= 1"
        class="btn btn-sm"
      >上一页</button>
      <span class="page-info">第 {{ page }} 页，共 {{ Math.ceil(total / size) }} 页，总计 {{ total }} 条</span>
      <button 
        @click="changePage(page + 1)" 
        :disabled="page >= Math.ceil(total / size)"
        class="btn btn-sm"
      >下一页</button>
    </div>
  </div>
  </ZoomPane>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import http from '@/api/http'
import ZoomPane from '@/components/ZoomPane.vue'

const articles = ref<any[]>([])
const loading = ref(false)
const page = ref(1)
const size = ref(10)
const total = ref(0)

const filters = ref({
  keyword: '',
  channel: ''
})

async function loadArticles() {
  loading.value = true
  try {
    const { data } = await http.get('/admin/articles', {
      params: {
        keyword: filters.value.keyword,
        channel: filters.value.channel,
        page: page.value,
        size: size.value
      }
    })
    articles.value = data.data.records
    total.value = data.data.total
  } catch (e: any) {
    alert('加载失败：' + (e.response?.data?.message || e.message))
  } finally {
    loading.value = false
  }
}

function search() {
  page.value = 1
  loadArticles()
}

function changePage(newPage: number) {
  page.value = newPage
  loadArticles()
}

async function publish(id: number) {
  try {
    await http.post(`/admin/articles/${id}/publish`)
    alert('发布成功')
    loadArticles()
  } catch (e: any) {
    alert('发布失败：' + (e.response?.data?.message || e.message))
  }
}

async function unpublish(id: number) {
  try {
    await http.post(`/admin/articles/${id}/unpublish`)
    alert('取消发布成功')
    loadArticles()
  } catch (e: any) {
    alert('操作失败：' + (e.response?.data?.message || e.message))
  }
}

async function deleteArticle(id: number) {
  if (!confirm('确定要删除这篇文章吗？')) return
  
  try {
    await http.delete(`/admin/articles/${id}`)
    alert('删除成功')
    loadArticles()
  } catch (e: any) {
    alert('删除失败：' + (e.response?.data?.message || e.message))
  }
}

function getChannelName(channel: string) {
  const map: Record<string, string> = {
    safety: '安全科普',
    news: '新闻资讯',
    guide: '使用指南'
  }
  return map[channel] || channel
}

function formatDate(dateStr: string) {
  if (!dateStr) return '-'
  return new Date(dateStr).toLocaleDateString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

onMounted(loadArticles)
</script>

<style scoped>
.article-admin {
  padding: 20px;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.filters {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
  align-items: center;
}

.search-input {
  flex: 1;
  max-width: 300px;
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.channel-select {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.table-container {
  background: white;
  border-radius: 8px;
  overflow-x: auto;
  overflow-y: hidden;
  box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

.article-table {
  width: 100%;
  border-collapse: collapse;
}

.article-table th,
.article-table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #eee;
}

.article-table th {
  background: #f8f9fa;
  font-weight: 600;
}

.article-title {
  display: flex;
  gap: 12px;
  align-items: flex-start;
}

.cover-thumb {
  width: 60px;
  height: 40px;
  object-fit: cover;
  border-radius: 4px;
}

.title {
  font-weight: 600;
  margin-bottom: 4px;
}

.summary {
  font-size: 12px;
  color: #666;
  max-width: 200px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.channel-tag {
  background: #e3f2fd;
  color: #1976d2;
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 12px;
}

.status {
  padding: 2px 8px;
  border-radius: 12px;
  font-size: 12px;
}

.status.published {
  background: #e8f5e8;
  color: #2e7d32;
}

.status.draft {
  background: #fff3e0;
  color: #f57c00;
}

.actions {
  display: flex;
  gap: 8px;
}

.btn {
  padding: 6px 12px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  text-decoration: none;
  font-size: 12px;
  transition: all 0.2s;
}

.btn-primary {
  background: #1976d2;
  color: white;
}

.btn-secondary {
  background: #757575;
  color: white;
}

.btn-success {
  background: #388e3c;
  color: white;
}

.btn-warning {
  background: #f57c00;
  color: white;
}

.btn-danger {
  background: #d32f2f;
  color: white;
}

.btn-sm {
  padding: 4px 8px;
  font-size: 11px;
}

.btn:hover {
  opacity: 0.8;
}

.btn:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 16px;
  margin-top: 20px;
}

.page-info {
  font-size: 14px;
  color: #666;
}

@media (max-width: 1024px){
  .article-admin{ padding:16px }
}

@media (max-width: 768px){
  .article-admin{ padding:12px }
  .header{ flex-direction: column; align-items: flex-start; gap: 8px }
  .filters{ flex-wrap: wrap; gap: 8px }
  .filters .search-input{ flex: 1 1 100%; max-width:none }
  .filters .channel-select{ flex: 1 1 48%; min-width: 140px }
  .filters .btn{ flex: 1 1 48% }

  .table-container{ margin: 0 -12px; padding: 0 12px }
  .article-table{ min-width: 720px }
  .article-table th, .article-table td{ padding:10px }

  .cover-thumb{ width:52px; height:36px }
  .summary{ max-width: 140px }
  .actions{ flex-wrap: wrap }
  .btn-sm{ margin-bottom: 6px }
}

@media (max-width: 380px){
  .article-table{ min-width: 640px }
}
</style> 