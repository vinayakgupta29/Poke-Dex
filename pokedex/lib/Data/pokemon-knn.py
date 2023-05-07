import numpy as np
import pandas as pd 
import flask as fl

app = fl.Flask(__name__)

@app.route('/api', methods=['POST'])
def get_similar_pokemon():
    # Get the input Pokemon name from the request body
    name = fl.request.json['name']
    try:
        # Read the Pokemon data from CSV
        pk = pd.read_csv("C:/Users/Vinayak/Documents/GitHub/Poke-Dex/pokedex/lib/Data/pokemon.csv")

        # Filter the dataframe based on the name of the Pokemon
        df = pk[pk['Name'].str.contains(name)]

        # Append the filtered dataframe to the original dataframe and remove duplicate Pokemon
        pk = pd.concat([df, pd.DataFrame(pk)], ignore_index=True).drop_duplicates(subset="id")

        # Calculate the Euclidean distance between each Pokemon and the input Pokemon
        stat = pk[['HP','Attack','Defense','Sp. Atk','Sp. Def','Speed']].values
        input_stat = np.tile(stat[0], (len(stat), 1))
        distances = np.sqrt(np.sum((stat - input_stat) ** 2, axis=1))
        pk['distance'] = distances

        # Sort the Pokemon by their distance from the input Pokemon
        pk = pk.sort_values('distance',ascending=True)

        # Get the top 5 similar Pokemon and return their names as a list
        newData=pk.drop(index=0)
        head = newData.head()
        


        similar_pokemon = head['Name'].tolist()
        
        return fl.jsonify({'pokelist': similar_pokemon})
    except Exception as e:
        error_msg = str(e)
        return fl.jsonify({'error': error_msg})

if __name__ == '__main__':
    app.run(debug=True)
