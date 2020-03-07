package rand

import "math/rand"

// Int returns a random int up to max
func Int(max int) int {
	return rand.Intn(max)
}
