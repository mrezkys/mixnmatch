//
//  ImagePicker.swift
//  mixnmatch
//
//  Created by Muhammad Rezky on 11/04/23.
//

import PhotosUI
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    enum PickerType {
        case photoLibrary
        case camera
    }

    @Binding var image: UIImage?
    @Binding var imagePath: String?
    let pickerType: PickerType

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PHPickerViewControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    if let image = image as? UIImage {
                        self.parent.image = image
                        if let data = image.pngData() {
                            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                            let imagePath = documentsURL.appendingPathComponent( UUID().uuidString + ".png")
                            do {
                                try data.write(to: imagePath)
                                self.parent.imagePath = imagePath.path
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)

            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                self.parent.image = image
                if let data = image.pngData() {
                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    let imagePath = documentsURL.appendingPathComponent( UUID().uuidString + ".png")
                    do {
                        try data.write(to: imagePath)
                        self.parent.imagePath = imagePath.path
                    } catch {
                        print(error)
                    }
                }
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    func makeUIViewController(context: Context) -> UIViewController {
        switch pickerType {
        case .photoLibrary:
            var config = PHPickerConfiguration()
            config.filter = .images
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = context.coordinator
            return picker
        case .camera:
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.allowsEditing = true
            picker.sourceType = .camera
            return picker
        }
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

