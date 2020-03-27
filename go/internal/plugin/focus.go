package plugin

import (
	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/go-flutter/plugin"
	"github.com/go-gl/glfw/v3.3/glfw"

	"mochi.io/internal/mochi"
)

// FocusCallback is a GLFWplugin
type FocusCallback struct {
	channel *plugin.MethodChannel
}

var _ flutter.Plugin = &FocusCallback{}     // compile-time type check
var _ flutter.PluginGLFW = &FocusCallback{} // compile-time type check
// FocusCallback struct must implement InitPlugin and InitPluginGLFW

// InitPlugin creates a MethodChannel for "samples.go-flutter.dev/focus"
func (p *FocusCallback) InitPlugin(messenger plugin.BinaryMessenger) error {
	p.channel = plugin.NewMethodChannel(messenger, "samples.go-flutter.dev/focus", plugin.StandardMethodCodec{})
	return nil
}

// InitPluginGLFW is used to gain control over the glfw.Window
func (p *FocusCallback) InitPluginGLFW(window *glfw.Window) error {
	window.SetFocusCallback(func(_ *glfw.Window, focused bool) {
		mochi.MarkWindowFocused(focused)
		p.channel.InvokeMethod("push/focus", map[interface{}]interface{}{
			"focused": focused,
		})
	})
	return nil
}
