# Inventory Management Portal

## Table of Contents

- [Install](#install)
- [Usage](#usage)

## Install

### Ruby Application

Install rvm and use ruby-3.4.2

```
curl -sSL https://get.rvm.io | bash
rvm use ruby-3.4.2

```

Install postgresql and create the user postgres

```
create role postgres with password secret;
# All this alter can be done in single step also ? Update this.
alter role postgres with superuser;
alter role postgres with login;

```

Install the rails dependencies for the project,

```
bundle install
```

Create database and Run the database migration and populate the seed data using following commands,

```
rails db:setup
rails db:full_reset
```

Refer the `full_reset.rake` file for user details

### Sample data

| User Email        | password |
| ----------------- | -------- |
| user1@example.com | password |
| user2@example.com | password |

## Usage

Start the rails server,

```
rails s
```
