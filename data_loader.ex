defmodule Dataloader do
    def import(filename \\ "pollution.csv") do
        File.read!(filename) |> String.split
    end        
    
    def notifyStations(list) do
       Enum.uniq_by(list, fn(station) -> station[:location] end)
    end
   
    def parseFile() do
        import() |> parseFile(%{})
    end

    def parseFile([], mapa) do mapa end
    def parseFile([head | tail], mapa) do 
        elem = parseLine(head)
        parseFile(tail, [elem | mapa]) 
    end

    def parseLine(line) do
        list = line |> String.split(",")
        [date1, time1, x, y, value1] = list
        %{
        :datetime       => {parseDate(date1), parseTime(time1)}, 
        :location       => parseLocation(x,y), 
        :pollutionLevel => parseValue(value1)
        }
    end

    def parseDate(date1) do
        date1 = date1 |> String.split("-")
        date1 = Enum.map(date1, &String.to_integer/1)
        List.to_tuple(date1) 
    end
    
    def parseTime(time1) do
        time1 = time1 |> String.split(":")
        time1 = Enum.map(time1, &String.to_integer/1)
        List.to_tuple(time1)
    end

    def parseLocation(x,y) do
        x = String.to_float(x)
        y = String.to_float(y)
        {x,y}
    end

    def parseValue(value1) do
        String.to_integer(value1)
    end
end

