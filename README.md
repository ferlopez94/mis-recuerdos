# Mis recuerdos
Repository for the iOS app "Mis recuerdos".

## Getting started

These instructions will help you to to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites
You need to have Xcode 8.3.3 installed on your local machine.

### Installing
Navigate to the location in which you want to store the project and clone it.

```
git clone https://github.com/ferlopez94/mis-recuerdos.git
```

Then open this project with Xcode.

## Modify project

### Prerequisites
To start working on a new feature first create a new branch.

```
git checkout -b branch-name
```

### Add components
Open the project with Xcode and create a new folder under "MisRecuerdos" folder with the name of the feature you're working on.

Inside your new folder create all of the related resources for your new feature. If you need to create a new resource that is used globally, put it inside the correct folder or create a new one if necessary.

Remember to update frequently the origin repo.

```
git push origin branch-name
```


### Update changes
Once you've finished with your feature, create a pull request for the dev branch.

Once your changes are reviewd, they will be merge with dev branch, and later with master branch.