# Paddy Sense - Deteksi Penyakit Daun Padi

Rice Leaf Disease Detection Application using MobileNetV3 and Hugging Face Inference API.

## Features

- 📸 **Real-time Detection**: Capture rice leaf images using smartphone camera
- 🤖 **AI-Powered**: MobileNetV3 model from Hugging Face for accurate disease classification
- 📊 **Dashboard**: View detection statistics and recent scan history
- 📚 **Disease Library**: Learn about 5 common rice leaf diseases
- 💾 **Local Storage**: Save detection history offline using Hive
- 🎨 **Modern UI**: Material Design 3 with minimalist aesthetics

## Detected Diseases

1. **Blast (Blas)** - *Pyricularia oryzae* - Fungal leaf disease
2. **Bacterial Leaf Blight** - *Xanthomonas campestris pv. oryzae* - Bacterial disease
3. **Tungro** - RTBV & RTSV - Viral disease
4. **Brown Spot** - *Bipolaris oryzae* - Fungal disease
5. **Healthy** - Normal rice plant condition

## Setup

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code
- Hugging Face API Token

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd paddy_sense
```

2. Install dependencies
```bash
flutter pub get
```

3. Generate Hive adapters
```bash
flutter pub run build_runner build
```

4. Configure Hugging Face API
   - Create a `.env` file in the root directory
   - Add the Space prediction endpoint:
```HF_ENDPOINT=https://huggingface.co/spaces/Woyazee/padi-mobilenetv3/predict```
> Note: This project uses Hugging Face Spaces which is publicly accessible, so **no API token is required**.

5. Run the app
```bash
flutter run
```

## Architecture

This project follows **Clean Architecture** principles:

```
lib/
├── core/               # Core utilities, constants, themes
├── data/              # Data layer (models, repositories, data sources)
├── domain/            # Domain layer (entities, use cases)
├── presentation/      # UI layer (screens, widgets, providers)
└── main.dart          # Entry point
```

## Technology Stack

- **Frontend**: Flutter (Dart)
- **State Management**: Riverpod
- **ML Model**: MobileNetV3 (Hugging Face)
- **Local Database**: Hive
- **HTTP Client**: Dio
- **Design**: Material Design 3

## Performance Targets

- ✅ Detection accuracy > 85%
- ✅ UI loading time < 200ms
- ✅ API response time < 3 seconds
- ✅ Smooth 60fps animations

## License

This project is developed for educational purposes.
