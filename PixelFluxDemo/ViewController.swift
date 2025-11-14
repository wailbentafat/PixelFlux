import UIKit
import PixelFlux

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let original = UIImage(named: "example") else {
            print("Image not found")
            return
        }

        do {
            let result = try BrightnessFilter(brightness: 0.3).apply(to: original)
            imageView.image = result
        } catch {
            print("Metal Error:", error)
        }
    }
}
