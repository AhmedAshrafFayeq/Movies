//
//  ViewController.swift
//  MovieApp
//
//  Created by Ahmed Fayek on 6/30/21.
//

import UIKit

class ViewController: UIViewController {
    
    var moviesArray: Array<Movie>?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getMovies()
    }
    
    func getMovies(){
        moviesArray = [Movie]()
        
        let url     = URL(string: "https://api.androidhive.info/json/movies.json")
        let request = URLRequest(url: url!)
        let session = URLSession(configuration: .default)
        
        let _    = session.dataTask(with: request) { (data, response, error) in
            print(data)
            print("data downloaded successfully")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Array<Dictionary<String,Any>>
                
                for rawMovie in json {
                    let movieObject = Movie()
                    movieObject.title = rawMovie["title"] as? String
                    movieObject.image = rawMovie["image"] as? String
                    movieObject.rating = rawMovie["rating"] as? Double
                    movieObject.relaseYear = rawMovie["relaseYear"] as? Int
                    
                    self.moviesArray?.append(movieObject)
                }
                
                for movie in self.moviesArray! {
                    print(movie.title)
                }
            }catch{
                print("error \(error)")
            }
        }.resume()
    }
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count \(moviesArray?.count ?? 0)")
        return moviesArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath)
        let textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.width, height: 30))
        textLabel.text = moviesArray?[indexPath.row].title
        cell.addSubview(textLabel)
        cell.backgroundColor = .blue
        return cell
    }

}
