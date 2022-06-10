package main

// Basic function declarations

func ReturnOne() int {
	return 0
}

func ReturnTwo() (int, int) {
	return 0, 0
}

func ReturnNamed() (x int) {
	return 0
}

func ReturnComplex() (q string, x, y int, w byte) {
	return q, x, y, w
}

// Basic function declarations on a single line

func SingleReturnOne() int                              { return 0 }
func SingleReturnTwo() (int, int)                       { return 0, 0 }
func SingleReturnNamed() (x int)                        { return 0 }
func SingleReturnComplex() (q string, x, y int, w byte) { return }

// Unicode

type Ühik int

func 你好() (ä, ü Ühik) { return 0, 0 }

// Methods

// Basic method declarations

func (ühik *Ühik) ReturnOne() int {
	return 0
}

func (ühik *Ühik) ReturnTwo() (int, int) {
	return 0, 0
}

func (ühik *Ühik) ReturnNamed() (x int) {
	return 0
}

func (ühik *Ühik) ReturnComplex() (q string, x, y int, w byte) {
	return
}

// Basic method declarations on a single line

func (ühik *Ühik) SingleReturnOne() int                              { return 0 }
func (ühik *Ühik) SingleReturnTwo() (int, int)                       { return 0, 0 }
func (ühik *Ühik) SingleReturnNamed() (x int)                        { return 0 }
func (ühik *Ühik) SingleReturnComplex() (q string, x, y int, w byte) { return }

// No receiver method declarations

func (*Ühik) NoReceive() {}
