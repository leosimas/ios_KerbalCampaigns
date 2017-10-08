# Kerbal Campaigns
An app with suggested campaigns for the game: Kerbal Space Program (https://kerbalspaceprogram.com).
Keep track of your missions as you explore the space.
The campaigns were created by the community and are available at: https://wiki.kerbalspaceprogram.com/wiki/Campaigns

## Requirements
* iOS 9+

## Build
This project uses CocoaPods, to install it follow the guide: https://cocoapods.org/#install
Then in the terminal install the Project dependencies:
```
$ pod install
```

And use the .xcworkspace file to open the project on XCode.

## Usage

### Campaigns List
The apps starts by loading the campaigns data from the Firebase and saving it using Realm to be available even it your are offline.
The list shows the campaigns name, estimated time to complete and its difficulty.
Tapping at one should show the campaign details

### Campaign details
In the details screen we have some new informations about it:
- the current progress
- a button with the number of completed and available missions
- the introduction text of the campaign
Tapping on the button should show the missions screen with first mission selected.

### Missions
The mission control screen. It shows a tab bar with all the missions and the details for each one:
- it shows the number of completed and available objectives.
- a checkbox for each objective
- and a list of tasks for each objectives
The users can mark each checkbox as they complete each mission and the progress of the campaign will be updated on all screens.
