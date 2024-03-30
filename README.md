# Bingo Madness

Welcome to Bingo Madness project repository. This project is designed to make childhood bingo game

## Features

- **Multiplayer** : Connect and play with other friends via internet
- **Chat option**  : Send messages during gameplay
- **Reaction**   : Send reactions [angry,sad,love,etc..] during gameplay

## Getting Started

### Prerequisites

Before begin make sure you have the following installed:

- Flutter 3.-.- (Above 3)

### Installation

1. Clone the repository

   ```
   git clone https://github.com/jibinkj-07/bingo-madness.git
   cd bingo-madness
   ```

### Code Structure

This project is following clean architecture with provider as state management.

- lib/core : Contains core functionalities for whole project includes custom styles, constant
  values, common widgets ,etc
- lib/features : Contains all modules for this project
    - /features/game : Module for core gaming performance
    - /features/lobby : Module for lobby operations like create and join game
    - /features/setting : Module for game settings like app sound

### Development Guidelines

- Follow clean architecture with SOLID principle.
- Use meaningful names for variables, functions and classes.
- Don\'t change core functionalities may lead to project break
- Utilize git with clear commit message

### Version History and Releases

- Android : 1.0.1+1 (30/03/24) - Completed Bingo madness game and ready for production