package main

import (
	"C"
	"fmt"
)

func main() {}

//export Test
func Test() {
	println("Test of the demo")
}

//export TestBoolean
func TestBoolean(parameter bool) {
	fmt.Printf("Input bool   : %t\n", parameter)
}

//export TestInt
func TestInt(parameter int) {
	fmt.Printf("Input int    : %d\n", parameter)
}

//export TestFloat
func TestFloat(parameter float32) {
	fmt.Printf("Input float  : %.10f\n", parameter)
}

//export TestDouble
func TestDouble(parameter float64) {
	fmt.Printf("Input double : %.10f\n", parameter)
}

//export TestString
func TestString(parameter string) {
	fmt.Printf("Input string : %s\n", parameter)
}

//export GetString
func GetString(index int) string {
	switch index {
	case 0:
		return "My index is 0."
	case 1:
		return "My index is 1."
	default:
		return "My index is either not 0 or 1."
	}
}