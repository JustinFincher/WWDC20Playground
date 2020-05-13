//#-hidden-code
//#-end-hidden-code

//: # 🧒 Getting Started
//: On this page, we will be learning the basic operation of shader programs. It is like writing C, as the underlying language cg is derived from C, but different in terms of scale, as your program will be executed for each pixel on the screen in parallel. First thing first, let's get some math done!
//: ## 🤔 0.5+0.5=?
//: You surely know 0.5 + 0.5 equals 1.0, but how do you express them in the Node Editor?
//: > ❓ Long press the running playground panel and you will see a list of operation nodes
//:
//: **Follow these steps:**
//: - Add a float generator [Menu - Generator - Float (float a)]
//: - Add another float generator [Menu - Generator - Float (float a)]
//: - Now add an add operator [Menu - Calculator - Add (float c = a + b)]
//: - Change two float nodes to 0.5 and 0.5
//: - Drag the output knot of the float node and connect it to the input knot of the add node (for each float generator node)
//: - See if the add node automatically changes values
//:
//: - Important:
//: 🚫 Don't mistake the vec2 add node with float add node. They are similar in math expressions, but different in the input format so you won't be able to assign float values to a vec2 node
//:
//: When finished, the node graph should be something similar to this:
//:
//: ![](BasicAddOperation.jpg)
//:
//: Now, what does it mean? In the shader world, we treat colors as RGB values, and each channel comes with a range from 0-1, which is why you are seeing pure white on the add node. The expression you composed with Shader Node Editor is essentially:
/*
 float float_a = 0.5;
 float float_b = 0.5;
 float channel = float_a + float_b;
 vec4 color = vec4(channel)
 */
//: > 🧐 You can change the value of each float generator and see how the color preview on the add node reacts to them.
//:
//: ➡️ Not bad, right? Let's switch to the next page add see some advanced usages.
