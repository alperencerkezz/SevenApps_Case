# SevenApps_Case
## Case Study for SevenApps

## Requirements
- iOS 18.2+
- Xcode 15.0+
- Swift 5.0+

## Installation
1. Clone the repository
2. Open Case.xcodeproj in Xcode
3. Build and run the project

## Architecture
The project follows the MVVM (Model-View-ViewModel) architecture pattern with the following components:

- **Models**: Data models representing the domain entities
- **Views**: UIKit views and view controllers
- **ViewModels**: Business logic and state management
- **Repository**: Data access layer
- **NetworkManager**: API communication layer

## Testing
The project includes unit tests for:
- Network Layer
- ViewModels
- Repository Layer

Run tests in Xcode using ⌘+U

## API
The app uses the JSONPlaceholder API:
- Users endpoint: https://jsonplaceholder.typicode.com/users
- User details: https://jsonplaceholder.typicode.com/users/{id}

## License
MIT License

## Screenshots

![image_alt](https://github.com/alperencerkezz/SevenApps_Case/blob/main/main.png?raw=true)

![image_alt](https://github.com/alperencerkezz/SevenApps_Case/blob/main/details.png?raw=true)
 
