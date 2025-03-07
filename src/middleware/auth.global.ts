import type { User } from '~/types/types'
import { useUser } from '@/composables/useUser'

type Role = 'GUEST' | 'USER' | 'ADMIN'

const routesPermissions = {
  login: ['GUEST'],
  index: ['GUEST', 'USER', 'ADMIN'],
  background: ['ADMIN'],
}

function getUserRole(user: User | null): Role {
  if (!user) return 'GUEST'
  return user.role
}

export default defineNuxtRouteMiddleware((to) => {
  const user = useUser()
  const role = getUserRole(user.value)
  // @ts-expect-error "Accessing routes permission"
  const permission = routesPermissions[to.name ?? 'index'] ?? []
  if (!permission.includes(role)) {
    return navigateTo('/')
  }
})
