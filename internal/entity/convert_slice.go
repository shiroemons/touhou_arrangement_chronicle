package entity

func ConvertSlice[T any, R any](src []T, f func(T) R) []R {
	dst := make([]R, len(src))
	for i, v := range src {
		dst[i] = f(v)
	}
	return dst
}
