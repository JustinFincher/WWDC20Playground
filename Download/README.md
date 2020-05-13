# README

You can also download the source code project on [https://github.com/JustinFincher/WWDC20Playground](https://github.com/JustinFincher/WWDC20Playground)

# Contact

Haotian Zheng  
[mailto:justzht@gmail.com](justzht@gmail.com)  
+86 18556572637 / +1 4697512468

# Tell us about the features and technologies you used in your Swift playground.

Shader Node Editor is a node-based shader editor framework I wrote for easy graphics programming on iPad (and Mac via Catalyst). The core of Shader Node Editor uses UIKit & UIKit Dynamics for layout and SpriteKit for shader preview & compilation, while the peripheral includes certain usages of AVFoundation, Combine, and SwiftUI.

Features:
- Visual scripting with a node-based editor
- Capability to easily extend the existing set of nodes even in runtime with subclassing
- Automatic shader preview updates
- Rich uniform input including audio, timestamp, and UV.
- Node-based UI framework developed for generic purposes that can be converted for storyline designer or state machine editor.

Technologies:
- UIKit Dynamics: the whole canvas along with various nodes follows physical rules in interactions thanks to UIKit Dynamics. You can drag & drop and they will maintain momentum until hitting the boundary.
- Node Graph: as SpriteKit already handles shader compilation for me, my editor only needs to do the code generation part. To generate OpenGL ES code, I deployed a 2-pass-brutal-force-approach. It is far from optimal, but at least it works: The first pass is responsible to use graph searching algorithms to gather linkage information and thus build a dependency graph for each node, and the second pass would declare variables for each knot on the nodes, append equal expressions on linked knots, and finally generate the shader code following the order previously collected in the dependency graph.
- Uniforms: shader uniforms like audio loudness are provided with Singletons for their sole purposes. Currently, the uniform value would be updated in a timer callback, but it can also be adjusted to follow SpriteKit drawing callbacks.

# Apps on the App Store (optional)

Developer page (with all apps included): https://itunes.apple.com/cn/developer/haotian-zheng/id981803173?mt=8

- Contributions For GitHub (https://itunes.apple.com/cn/app/contributions-for-github/id1153432612?mt=8) A small app for viewing your GitHub contributions graph in 2D / 3D perspective. Available on iOS and watchOS.
- Epoch Core (https://itunes.apple.com/cn/app/epoch-core/id1177530091?mt=8) Tech demo for showing off my noise shader and procedurally generated planet terrain. It can generate near 1 million different planets.
- ArtWall (https://itunes.apple.com/cn/app/artwall/id1178151992?mt=12) If you are a digital artist or just a person who likes digital art, ArtWall is here for you to save ArtStation images as your desktop wallpaper.
- Golf GO (https://itunes.apple.com/cn/app/golf-go-scholarship-edition/id1380656648?mt=8) WWDC 18 winner project, a mini-golf game with infinite golf maps to play. Written in 1000 Swift lines.