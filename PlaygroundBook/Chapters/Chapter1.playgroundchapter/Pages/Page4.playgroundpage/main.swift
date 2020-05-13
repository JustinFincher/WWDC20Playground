//#-hidden-code
//#-end-hidden-code
//: # 🧑‍💻 Video Jockey
//: VJ is like a DJ, but with visuals. Shaders are especially well-fit for such scenarios, let's make an audio-reactive shader that changes with music loudness! 🎶
//: ![](AudioShader.jpg)
//:
//: **Follow these steps:**
//: - Add a uv center atan generator [Menu - Generator - UV Center Atan (atan(uv-vec2(0.5)))]
//: - Add a audio db generator [Menu - Generator - Audio DB (float u_audiodb)]
//: - Add a disc ray consumer [Menu - Consumer - Float Disc Ray]
//: - Add a circle outline consumer [Menu - Consumer - Float Circle Outline]
//: - Add several float generator nodes, either a float value node [Menu - Generator - Float Generator] or a float slider node [Menu - Generator - Float Slider], and assign them to these fields: Ray Num 1, Ray Num 2 in Disc Ray node and In Radius, Out Radius in Circle Outline node.
//:
//: > Ensure that ray numbers are > 2 as well as 0 < in radius < out radius < 1 to get desired results
//:
//: Now play some music, you will find the outline circle shakes with the loudness of the music 🔊.
//:
//: ## 🥳 This is the end of the book, hope you learned something useful!
