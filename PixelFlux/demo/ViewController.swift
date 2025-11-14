import UIKit


class ViewController: UIViewController {
let imageView = UIImageView()


override func viewDidLoad() {
super.viewDidLoad()
view.backgroundColor = .white
imageView.frame = view.bounds
imageView.contentMode = .scaleAspectFit
imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
view.addSubview(imageView)


guard let demo = UIImage(named: "demo.jpg") else { return }
imageView.image = demo


DispatchQueue.global(qos: .userInitiated).async {
do {
let out = try PixelFlux.shared.applyBrightness(to: demo, brightness: 0.3)
DispatchQueue.main.async {
self.imageView.image = out
}
} catch {
print("PixelFlux error:", error)
}
}
}
}
