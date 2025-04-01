import type { User } from '~/types/types'

export const useUser = () => useState<User | null>('user', () => null)
