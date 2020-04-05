package gomobile

import (
	"errors"

	"mochi.io/internal/daemon"
)

func init() {
	daemon.StartDaemon(10101, 10801)
}

type (
	// DataProcessor :
	DataProcessor struct {
		// add fields here
	}
)

// Increment : Increment the int received as an argument.
func (p *DataProcessor) Increment(data int) (int, error) {
	if data < 0 {
		// Return error if data is negative. This will
		// result exception in Android side.
		return data, errors.New("data can't be negative")
	}
	return (data + 1), nil
}
