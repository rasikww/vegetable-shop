# Thoga Kade Vegetable Shop CLI

A command-line interface for managing a vegetable shop's inventory and orders.

## Table of Contents

- [Thoga Kade Vegetable Shop CLI](#thoga-kade-vegetable-shop-cli)
  - [Table of Contents](#table-of-contents)
  - [Getting Started](#getting-started)
  - [Features](#features)
  - [Usage](#usage)
  - [Testing](#testing)

## Getting Started

Clone the repository.

To run the application, navigate to the project directory and execute the following command:

```bash
dart bin/cli/command_handler.dart
```

## Features

- Manage vegetable inventory.

- Add, update, and remove vegetables.
- Place orders and update inventory accordingly.

## Usage

The application presents a menu-driven interface. The user can select options to perform various actions.

0: Exit the application
1: Add a vegetable to the inventory
2: View the current inventory
3: Update the stock of a vegetable
4: Remove a vegetable from the inventory
5: Place an order
6: Generate a report (WIP)

## Testing

The application includes unit tests to ensure its correctness. To run the tests, execute the following command:

```bash
dart test test\<test_file_path_and_name>
```
