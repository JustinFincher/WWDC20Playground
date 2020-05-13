//#-hidden-code
//#-end-hidden-code
//: # 🧑‍🎓 Advanced Usage
//: This page would guide you to write animating shaders.
//: ## ☝️ Introduction of UV
//: We will be using UV to assign different colors to pixels in different positions.
//:
//: **Follow these steps:**
//: - Add a uv generator [Menu - Generator - UV (vec2 v_tex_coord)]
//:
//: ![](UVNode.jpg)
//: You will see a node with a green-to-red color gradient. What is the meaning of this gradient? You might ask.
//: Remember how we represent values with colors in the 0.5+0.5 example? At that time, we were using a single value for all three color channels (R(red), G(green), B(blue)). Now if you only increase a single channel (for example, red channel) along an axis (for example, x-axis), the color would be more prominent(red-ish) following the axis. And when you increased both values in red and green, you get yellow.
//:
//: ## 🔵 I want blue!
//: OK then, what should we do now? We need a float node with value 1.0 and assign the value to the B field in RGB.
//: - Add a float generator [Menu - Generator - Float (float a)]
//: - Add a vec2 split packer [Menu - Packer - Vec2 Split (float x = v.x, y = v.y)]
//: - Add a vec4 combine packer [Menu - Packer - Vec4 Combine (vec4 c = vec4(r,g,b,a))]
//: - Drag knots so that the vec2 value in the UV node is split to two float values and routed to the R and G knots in the vec4 combine node.
//: - Drag knots that the float value in the single float generator node is connected to the B knots in the vec4 combine node.
//:
//: ![](UVPlusBlue.jpg)
//:
//: With the value of B being 1.0, the color previously in the red-green gradient is now pink-cyan. This is because we preserved the R and G values but added a constant blue value to each pixel on the screen.
//:
//: - Important:
//: If you connected the wrong knot, don't worry. Simply long-press on the end of the line and drag it out of the knot.
//:
//: ## 🎞 Shader animation techniques
//: Animation means the value changes over time. Now think of this: **if we use a sin() node with the current timestamp since app startup, we would transform the ever-increasing value to a value bouncing between -1.0 and 1.0.**
//: If we write it down in cg programming language, it would be:
/*
vec2 uv = v_tex_coord;
float time = u_time;
float bounce = sin(time);
vec3 color = (uv.x, uv.y, bounce); // instead of constant (uv.x, uv.y, 1.0)
 */
//: > The 'v_tex_coord' and 'u_time' are system variables in the shader program(the prefix 'v' and 'u' stand for vary and uniform), and they are fed by the system so we can use it as-is.
//:
//: **Follow these steps:**
//: - Long press the float generator node and delete it
//: - Add a time generator node [Menu - Generator - Time (float u_time)]
//: - Add a sin modifier node [Menu - Modifer - Float Sin (float b = sin(a))]
//: - Connect the nodes so the time value would flow through sin function and finally feed the B value in the vec4 combine node.
//:
//: ![](UVWithSinAsBlue.jpg)
//:
//: You would see the sin node fades between black and white (-1 to 1 actually, but values below 0 are always black, whatever). The vec4 combine node is also animating as the blue channel is following the trace.
//:
//: 😇 Congrats! Now you are a shader programmer. Many shaders follow the same suit, but packed with more operators and more math logic, but that is another story, how about we now go to a party and play some music?
//:
//: > ➡️ Switch to the next page and we will see how to write a music-reactive shader.
