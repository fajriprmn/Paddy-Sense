# Paddy Sense - Setup Guide

Complete guide to set up and run the Rice Leaf Disease Detection application.

## Prerequisites

1. **Flutter SDK** (version 3.0.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter doctor`

2. **Android Studio** or **VS Code** with Flutter extensions

3. **Hugging Face Account**
   - Sign up at: https://huggingface.co/
   - Get your API token from: https://huggingface.co/settings/tokens

## Step 1: Install Dependencies

Navigate to the project directory and run:

```bash
cd "c:\Users\suneo\Documents\Kuliah\Skripsi\Paddy Sense"
flutter pub get
```

## Step 2: Generate Hive Adapters

Run the build runner to generate Hive type adapters:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Step 3: Configure Hugging Face API

1. Open `lib/presentation/providers/detection_provider.dart`

2. Replace the placeholder values with your actual credentials:

```dart
final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  const apiToken = 'YOUR_HUGGINGFACE_API_TOKEN';  // Replace this
  const modelId = 'YOUR_MODEL_ID';                 // Replace this
  
  return RemoteDataSource(
    apiToken: apiToken,
    modelId: modelId,
  );
});
```

### Finding Your Model ID

- If you're using a pre-trained model from Hugging Face, the model ID format is: `username/model-name`
- Example: `nateraw/food` or `your-username/rice-disease-classifier`
- You can also train your own MobileNetV3 model and upload it to Hugging Face

## Step 4: Create Asset Directories

Create the required asset directories:

```bash
mkdir assets
mkdir assets\images
mkdir assets\icons
```

## Step 5: Run the Application

### For Android:

```bash
flutter run
```

### For iOS (macOS only):

1. Navigate to iOS directory:
```bash
cd ios
pod install
cd ..
```

2. Run the app:
```bash
flutter run
```

## Step 6: Build for Release

### Android APK:

```bash
flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store):

```bash
flutter build appbundle --release
```

### iOS (macOS only):

```bash
flutter build ios --release
```

## Troubleshooting

### Issue: Camera permission denied

**Solution**: Make sure you've added camera permissions in `AndroidManifest.xml` (already included)

### Issue: Hive adapter not found

**Solution**: Run the build runner command again:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: API returns 401 Unauthorized

**Solution**: Check that your Hugging Face API token is correct and has the necessary permissions

### Issue: Model not found (404 error)

**Solution**: Verify your model ID is correct. The format should be `username/model-name`

## Testing the App

1. **Dashboard**: Should display 0 scans initially
2. **Camera**: Tap "Mulai Deteksi" to open camera
3. **Take Photo**: Point camera at a rice leaf and tap the green button
4. **View Result**: See the detection result with disease name and confidence
5. **History**: Check the history tab to see saved detections
6. **Library**: Browse the disease library for information

## Training Your Own Model

If you want to train your own MobileNetV3 model:

1. Collect rice leaf images (healthy and diseased)
2. Label them according to disease types
3. Train using TensorFlow/PyTorch
4. Convert to MobileNetV3 format
5. Upload to Hugging Face
6. Use your model ID in the app

### Recommended Dataset Structure:

```
dataset/
├── Blast/
├── BacterialLeafBlight/
├── Tungro/
├── BrownSpot/
└── Healthy/
```

## API Configuration

The app expects the Hugging Face model to return predictions in this format:

```json
[
  {
    "label": "Blast",
    "score": 0.94
  },
  {
    "label": "Healthy",
    "score": 0.06
  }
]
```

Supported labels:
- `Blast`
- `BrownSpot`
- `Tungro`
- `BacterialLeafBlight`
- `Healthy`

## Performance Optimization

1. **Image Compression**: Images are automatically compressed to 512x512px before upload
2. **Caching**: Detection history is cached locally using Hive
3. **Offline Support**: View history even without internet connection

## Next Steps

1. Add your Hugging Face API credentials
2. Test with sample rice leaf images
3. Customize the UI colors in `lib/core/constants/app_colors.dart`
4. Add more disease information in `lib/data/datasources/disease_data_source.dart`

## Support

For issues or questions:
- Check the Flutter documentation: https://flutter.dev/docs
- Hugging Face documentation: https://huggingface.co/docs
- Create an issue in the project repository

## License

This project is for educational purposes.
