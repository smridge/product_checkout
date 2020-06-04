# Product Checkout

## Install if needed

### Ruby Version
```bash
$ rvm install "ruby-2.7.1"
```

### Postgresql
```
$ brew install postgresql
```

## Clone, Setup, Start Server
```
$ git clone git@github.com:smridge/product_checkout.git
$ cd product_checkout
$ bundle install
$ rails db:setup
$ bundle exec rails s
```

## Example Requests
*API Testing Tool Used: `insomnia`. Install via `brew cask install insomnia`.*

### Create new Checkout Transaction via `POST`
```
http://localhost:3000/transactions/?transaction[product_codes]=["CC", "PC", "WA"]
```

#### Example `POST` Response
```json
{
  "id": 1,
  "details": {
    "purchases": {
      "CC": 1,
      "PC": 1,
      "WA": 1
    },
    "total": "4.35"
  },
  "created_at": "2020-06-04T03:05:52.938Z",
  "updated_at": "2020-06-04T03:05:52.938Z"
}
```

### Get Checkout Transactions via `GET`
- All Transactions
  ```
  http://localhost:3000/transactions
  ```

- With `start_date` parameter
  ```
  http://localhost:3000/transactions/?start_date=2020-06-01
  ```

- With `end_date` parameter
  ```
  http://localhost:3000/transactions/?end_date=2020-06-01
  ```

- With `start_date` and `end_date` parameters
  ```
  http://localhost:3000/transactions/?start_date=2020-06-01&end_date=2020-06-03
  ```

#### Example `GET` Response
```json
{
  "transactions": [
    {
      "total": "4.35",
      "purchases": {
        "CC": 1,
        "PC": 1,
        "WA": 1
      },
      "created_at": "2020-06-04 03:05:52 UTC"
    },
    {
      "total": "5.0",
      "purchases": {
        "CC": 3,
        "PC": 1
      },
      "created_at": "2020-06-04 03:06:15 UTC"
    },
    {
      "total": "7.15",
      "purchases": {
        "CC": 2,
        "PC": 3,
        "WA": 1
      },
      "created_at": "2020-06-04 03:06:56 UTC"
    }
  ],
  "purchase_totals": "16.5"
}
```

## Running Tests
- Entire Suite
  ```
  $ rspec spec --format documentation
  ```

- Specific Unit
  ```
  $ rspec spec/classes/checkout_spec.rb --format documentation
  ```
