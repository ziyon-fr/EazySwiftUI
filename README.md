# EazySwiftUI

**EazySwiftUI** is a growing collection of beautifully crafted SwiftUI components and animations that help iOS developers build engaging and modern UIs faster and with ease.

## 🚀 Features

- ✅ Plug-and-play SwiftUI components  
- 🎨 Beautiful and customizable UI elements  
- ✨ Smooth built-in animations  
- 🧱 Modular architecture for easy integration  
- 📦 Swift Package Manager support  

## 📦 Installation

### Swift Package Manager (Recommended)

1. Open your Xcode project.  
2. Go to **File > Add Packages…**  
3. Paste the following URL into the search bar:
   https://github.com/ziyon-fr/EazySwiftUI.git
   
5. Choose the latest version and add the package to your app target.

## 🛠️ Usage

After adding the package to your project, simply import it into your SwiftUI views:

<pre lang="swift">
import SwiftUI
import EazySwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            BlurView()
                .padding()
        }
    }
}
</pre>

 ## 🧩 Components:
 
  **BlurView** – A struct that represents a blur effect view using UIViewRepresentable.
  
  **StatefulPreview** – A view container that provides state capabilities for PreviewProvider.

 ## ✨ Animations:
 
  **Shimmer Effect** – Adds a shimmer effect to any view, with customizable parameters like color, speed, and direction.
  **Wiggle Animation** - Adds a wiggle effect to the view, making it shake or wiggle.

## Extenstions:
**Extension CGSize** - A set of predefined common `CGSize` values for various use cases like iPhoneSizes
**Extension Shape** -
**Extension View**

## 🤝 Contributing

Contributions are welcome! To contribute:
	1.	Fork the repository
	2.	Create a new branch (git checkout -b feature-name)
	3.	Commit your changes (git commit -am 'Add new feature')
	4.	Push to the branch (git push origin feature-name)
	5.	Create a new Pull Request

Please ensure your code is clean, well-documented, and adheres to Swift best practices.

## 📄 License

EazySwiftUI is released under the MIT License.

## 🙌 Acknowledgments

Created and maintained by **ZIYØN SAS**.

---

Let me know if you'd like a badge section at the top (e.g., Swift version, license, platforms supported), or a GitHub Pages demo link if you plan to showcase a preview site!


