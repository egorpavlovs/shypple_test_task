# README

##  Solution
All logic is in `app/services/shypple_service/` and `app/services/shypple_service.rb`

For maximum project scalability, all stages of searching for the required shipment are isolated as much as possible for change/scale.
- The necessary shipment search strategy is selected in `app/services/shypple_service.rb`, depending on the name (`PLS-0001`, `WRT-0002` etc.). Strategies are implemented in `app/services/shypple_service/strategies/`. Strategies specify the basic logic for searching for shipment.
- Sailings can only be direct or indirect. In case of adding new types of sailings (for example, with the requirement “do not sail to port XXXX”), a new sailing can be added to `app/services/shypple_service/sailings/` and to `app/services/shypple_service/sailings.rb`
- The source of information is a file, but the source may change. It can also be different in different strategies. To change source, you can specify a new source type in `app/services/shypple_service/sources/` and call it with `app/services/shypple_service/get_information.rb`.
- The result of all elements is unified by using `app/services/shypple_service/utils/result.rb`. This helps to always know in what format the information comes and how to process it.

## Application use
```
rails s -p 3000

curl -XGET 'http://localhost:3000/shipments/PLS-0001?origin_port=CNSHA&destination_port=NLRTM'
```
`PLS-0001` - shipment type, `origin_port` - departure port, `destination_port` - destination port.

## Tests run
```
   rspec spec
```

## What can be improved
- Add rubocop/breakman, etc.
- Unify responses (now json is returned if everything is ok, and a string if there is an error).
- Add `shared_examples` for tests.
