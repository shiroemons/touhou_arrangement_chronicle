export interface User {
  id: string
  email: string
  name?: string
  picture?: string
  nickname?: string
}

export interface AuthState {
  user: User | null
  isAuthenticated: boolean
} 