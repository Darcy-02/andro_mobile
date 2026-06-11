# ANDRO

A mobile-first student engagement platform for African Leadership University, Kigali campus. Built with Flutter.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Design System](#design-system)
- [Team](#team)
- [License](#license)

---

## Overview

ANDRO is a campus engagement application scoped exclusively to ALU Kigali. It gives students, club leaders, event organisers, and faculty a single platform to discover opportunities, participate in campus activities, build communities, and connect with each other.

The platform addresses a concrete problem: opportunities at ALU Kigali are fragmented across WhatsApp groups, email threads, and physical notice boards. ANDRO centralises them into a ranked, filterable feed and pairs discovery with direct participation tools — RSVP, community joining, event chat, and profile-based identity.

This application was built as a Mobile App Development assignment at ALU. The focus is UI/UX design and interaction flow. Data is mocked locally; backend integration is optional.

---

## Features

### Authentication and Onboarding

Users sign in with their ALU institutional email or via Google/Apple OAuth restricted to ALU domains. First-time users are walked through a four-step onboarding wizard covering identity, campus confirmation, interest tag selection, and role declaration. Sessions persist across app restarts.

### Home Feed

The main feed surfaces events and opportunities ranked by a combination of recency, interest tag match, and community membership. A featured carousel at the top displays administrator-pinned posts. Category tabs allow filtering by Events, Opportunities, Clubs, and Academics. A Latest Opportunities strip shows the three most recently posted non-event listings.

### Events and Opportunities

Authorised users can post two types of content. Events include a title, description, cover image, date and time, campus location, capacity limit, and category tags. Opportunities cover internships, fellowships, competitions, and leadership programmes, with application deadlines, eligibility notes, and external apply links. Posts go through Draft, Published, Past, and Cancelled lifecycle states.

### RSVP and Participation Management

Students can respond to events with two states: Interested (a soft bookmark that triggers a reminder notification) and Going (a confirmed RSVP that counts toward capacity). When an event reaches capacity, subsequent Going responses are placed on a waitlist with visible position. Students manage all their responses from the My RSVPs screen, which is divided into Going, Interested, and Past tabs. Event organisers see a real-time attendance breakdown and an attendee list from the event management view.

### Communities and Clubs

Students can discover and join clubs and student groups from the Communities section. Each community has a profile with a description, member count, admin list, and a feed of associated posts. Club leaders can manage membership, pin announcements, and create events pre-tagged to their community. Communities can be set to open or approval-required.

### Chat and Communication

Chat spaces are attached to events and communities rather than existing as free-floating conversations. Event chats are created automatically when an event is published and remain active for seven days after the event ends. Community chats are permanent. Announcement channels allow admin-only posting for broadcasting to all members. Direct messaging between any two students is also supported. Messages support text, file attachments, image uploads, emoji reactions, and reply threading.

### Profile and Identity

Every student has a profile showing their name, programme, graduation year, campus, bio, and interest tags. A stats bar displays Events Attended, Communities joined, and Connections made, each tappable to show the underlying list. Students can view their own posts and saved items from the profile. Connections are mutual — both parties must accept before either appears in the other's connections list.

### Search and Exploration

The Explore tab provides a global search bar that matches post titles, community names, and user display names. Results can be filtered by category, date range, and interest tags. A Recommended for You section surfaces content based on the student's onboarding interests. A Trending This Week section ranks posts by engagement rate over the past seven days.

### Notifications

The platform sends in-app and push notifications for event reminders at 24 hours and 1 hour before start, waitlist promotions, event cancellations, new opportunities matching a student's interest tags, connection requests, and chat mentions. Students can configure notification preferences per category from the Settings screen.

### Post Creation

The Create screen, accessible from the bottom navigation bar, allows authorised users to choose between posting an Event or an Opportunity, fill in the relevant fields, upload a cover image, set visibility (ALU-wide or community-specific), and publish or save as a draft. The screen is locked for standard Student accounts with a prompt to request an elevated role.

### Startup Showcase

Students can submit a startup profile including a name, one-line pitch, development stage, description, pitch deck link, and open roles they are hiring for. Other students can express interest or apply to join the team. The showcase is browseable from the Explore tab and filterable by stage.

### QR Code Check-In

Organisers generate a unique QR code per event from the attendance management screen. Students who have RSVPed Going can scan the code on the day to mark themselves as attended. Check-in data feeds into organiser analytics and the student's Events Attended count on their profile.

### Campus Map and Room Locator

Event detail screens include a map tab showing the ALU Kigali campus layout with the event location pinned. Organisers select from a pre-populated directory of campus buildings and rooms when creating a post. A Get Directions button deep-links to Google Maps with the campus coordinates pre-filled. Going students receive the room in their 1-hour reminder notification.

### Achievement Badges

Students earn badges displayed on their profile: First Event (attended first QR-verified event), Community Builder (joined five or more communities), Connector (made ten connections), Organiser (hosted an event with twenty or more attendees), Campus Regular (attended events in three different campus locations), and Pitch Ready (submitted a startup to the showcase).

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State management | Riverpod 2.x |
| Navigation | GoRouter |
| Local persistence | sqflite, shared_preferences |
| Data | Mock data in Dart model classes |
| Image handling | cached_network_image, image_picker |
| Charts | fl_chart |
| Backend (optional) | Firebase Firestore, Firebase Storage |

---

## Getting Started

### Prerequisites

- Flutter SDK 3.x or later
- Dart 3.x
- Android Studio or VS Code with the Flutter extension
- An Android emulator or iOS simulator, or a physical device

### Installation

```bash
git clone https://github.com/your-org/andro.git
cd andro
flutter pub get
```

### Running the app

```bash
flutter run
```

To run on a specific device:

```bash
flutter devices
flutter run -d <device_id>
```

### Building a release APK

```bash
flutter build apk --release
```

---

## Project Structure

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   └── router/
│       └── app_router.dart
├── models/
│   ├── user_model.dart
│   ├── event_model.dart
│   ├── opportunity_model.dart
│   ├── community_model.dart
│   ├── message_model.dart
│   ├── rsvp_entry.dart
│   └── startup_model.dart
├── mock/
│   ├── users.dart
│   ├── events.dart
│   ├── communities.dart
│   └── startups.dart
├── features/
│   ├── auth/
│   │   ├── screens/
│   │   └── providers/
│   ├── feed/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── providers/
│   ├── events/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── providers/
│   ├── communities/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── providers/
│   ├── chat/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── providers/
│   ├── profile/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── providers/
│   ├── rsvp/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── providers/
│   ├── startups/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── providers/
│   └── notifications/
│       ├── screens/
│       └── providers/
└── main.dart
```

---

## Design System

The application uses a dark theme throughout. The primary background is `#0D1117`, card surfaces are `#1C2333`, and elevated surfaces such as modals are `#243044`. The gold accent colour `#E5A020` is used for calls to action, active states, and key data points. Primary text is `#F0F6FC` and secondary text is `#8B949E`. All borders use `#30363D`.

Card radius is `12px`. Button radius is `10px`. Pill and badge radius is `20px`.

---

## Team

| Name | Role |
|---|---|
| Ayomide | Profile and engagement — profile screen, RSVP management, startup showcase, connections |
| Darcy | App foundations — navigation, authentication, onboarding, app shell |
| Kuda | Communities and exploration — community profiles, discovery, search, campus map |
| Yves | Chat and notifications — chat rooms, announcement channels, notification centre |
| Ivan | Home feed and content — feed rendering, event detail, post creation, QR check-in |

---

## License

This project was built as an academic assignment for the Mobile App Development course at African Leadership University. It is not licensed for commercial use.