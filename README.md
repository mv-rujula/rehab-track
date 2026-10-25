# rehab_track

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# RehaTrack-ML

Machine learning experiments for RehaTrack, a rehabilitation application focused on exercise tracking and movement analysis.

## Current Work

- **Pose estimation:** MediaPipe Pose Landmarker Lite
- **Exercise tracking:** Bicep curl repetition counting
- **Joint analysis:** Shoulder, elbow, and wrist landmark tracking
- **Angle calculation:** Elbow angle estimation during exercise
- **Data collection:** Scripts for collecting exercise data for future ML experiments

## Project Structure

```text
ml-experiments/
├── bicep_curl.py
├── pose_webcam.py
├── requirements.txt
└── models/
    ├── collect_data.py
    └── pose_landmarker_lite.task
```

## Setup

Create and activate a Python virtual environment, then install the dependencies:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r ml-experiments\requirements.txt
```

## Running the Experiments

Run the webcam pose detection experiment:

```powershell
python ml-experiments\pose_webcam.py
```

Run the bicep curl experiment:

```powershell
python ml-experiments\bicep_curl.py
```

Run the data collection script:

```powershell
python ml-experiments\models\collect_data.py
```

## Current Goals

- Improve exercise repetition counting.
- Collect labelled exercise movement data.
- Explore posture feedback and movement classification.
- Evaluate suitable ML approaches for rehabilitation tracking.

## Notes

These experiments are part of the ongoing development of RehaTrack. Features and implementation details may change as the project evolves.

## Personalized Bicep-Curl Prototype

RehaTrack currently includes a laptop-based prototype that monitors
bicep curls against a selected, user-specific demo prescription.

The prototype uses MediaPipe pose landmarks to estimate the elbow
angle, count movement cycles that meet configured endpoints, provide
phase-specific instructions, and save session results.

Personalization currently means following an entered prescription.
The system does not diagnose conditions, generate treatment plans,
or automatically change a user's prescription.

### Current Features

- Live webcam pose tracking.
- Image-plane elbow-angle calculation.
- Configurable extension and flexion endpoints.
- Repetition counting using an extended → flexed → extended cycle.
- Angle smoothing and a configurable endpoint hold.
- Movement-state reset when arm tracking is unavailable.
- Two fictional demo prescription profiles.
- 

## Personalized Bicep-Curl Prototype

RehaTrack currently includes a laptop-based prototype that monitors
bicep curls against a selected, user-specific demo prescription.

The prototype uses MediaPipe pose landmarks to estimate the elbow
angle, count movement cycles that meet configured endpoints, provide
phase-specific instructions, and save session results.

Personalization currently means following an entered prescription.
The system does not diagnose conditions, generate treatment plans,
or automatically change a user's prescription.

### Current Features

- Live webcam pose tracking.
- Image-plane elbow-angle calculation.
- Configurable extension and flexion endpoints.
- Repetition counting using an extended → flexed → extended cycle.
- Angle smoothing and a configurable endpoint hold.
- Movement-state reset when arm tracking is unavailable.
- Two fictional demo prescription profiles.
- Profile-specific repetition targets and movement instructions.
- On-screen target-completion feedback.
- Local JSON session summaries.

### Demo Profiles

These values are illustrative software-test settings, not medical
recommendations.

| Profile | Target repetitions | Extension endpoint | Flexion endpoint |
|---------|--------------------|--------------------|------------------|
| demo_a | 5 | At least 150° | At most 60° |
| demo_b | 3 | At least 140° | At most 80° |

The current webcam implementation tracks the configured right-arm
landmarks. Left-arm selection is not implemented yet.

Angles use the included elbow-angle convention: a straighter elbow
has a larger angle.

### Project Files

```text
ml-experiments/
├── bicep_curl.py
├── pose_webcam.py
├── prescriptions.json
├── models/
│   ├── collect_data.py
│   └── pose_landmarker_lite.task
└── session_results/        # Generated locally; excluded from Git
```

The data collector is retained as a separate experiment.
It is not required to run the live demonstration.

### Requirements

- A working webcam.
- A Python environment with compatible OpenCV and MediaPipe packages.
- The MediaPipe Pose Landmarker model at:
  `ml-experiments/models/pose_landmarker_lite.task`

The current camera-opening code uses Windows DirectShow.
Other operating systems may require a different OpenCV camera backend.

### Run the Prototype

Run these commands from the repository root, using the project's
configured Python environment.

Demo User A:

```powershell
python .\ml-experiments\pose_webcam.py --profile demo_a
```

Demo User B:

```powershell
python .\ml-experiments\pose_webcam.py --profile demo_b
```

Press Q or Esc while the camera window is active to end the session.

If an endpoint cannot be reached comfortably, do not force the
movement to satisfy a demo setting.

### Prescription Configuration

Profiles are stored in:

```text
ml-experiments/prescriptions.json
```

Each profile specifies:

- Display name.
- Exercise.
- Arm.
- Target repetitions.
- Extension angle.
- Flexion angle.

The current implementation supports right-arm bicep curls only.
The selected profile is loaded at session start.

Changing the profile changes the endpoints used by the counter and
the displayed repetition target.

### Session Results

When a session ends normally, a JSON summary is saved under:

```text
ml-experiments/session_results/
```

The summary includes:

- Session identifier.
- Start and end timestamps in UTC.
- Session duration.
- Input source.
- Selected profile identifier.
- Full prescription snapshot.
- Qualifying repetition count.
- Target repetition count.
- Whether the target was reached.
- Remaining repetitions.
- Wearable integration status.
- Prototype limitations.

Reaching the repetition target displays a message but does not
automatically close the session.

Session files are local outputs and should not contain real patient
information in this demonstration.

### Manual Verification to Date

- Both demo profiles load their configured settings.
- Webcam tracking displays elbow angles and repetition counts.
- Demo User B completed a test session with 3/3 recorded repetitions.
- A completed-session summary was saved successfully.
- A zero-repetition Demo User A session saved with
  `target_reached: false`.

These checks demonstrate basic operation only. They are not a
formal accuracy evaluation or clinical validation.

### Limitations

- Elbow angle is estimated from 2D image coordinates.
- Camera viewpoint, occlusion, and landmark errors can affect results.
- Counting endpoint cycles does not establish complete exercise
  correctness or safety.
- Tracking interruptions reset the unfinished movement but are not
  yet recorded in the session summary.
- The prototype does not currently evaluate all compensation patterns.
- Wearable measurements are not used by this camera demonstration.
- No automatic prescription generation or progression is implemented.
- The Python prototype does not establish that Flutter–Python
  integration is complete.
- Forced termination or power loss may prevent session saving.

### Planned Work

- Deterministic automated tests for counting and configuration.
- More systematic manual accuracy testing.
- Tracking-interruption and deviation-event logging.
- ESP32 + MPU6050 data collection and verification.
- Tested camera/wearable decision integration.
- Integration with the existing Flutter interface.
- Left-arm support.

### Safety and Privacy

This is an engineering proof of concept, not a medical device or a
replacement for a physiotherapist.

Real rehabilitation targets must come from an appropriate clinician.
Do not commit patient information, credentials, local environments,
or private recordings to the repository.