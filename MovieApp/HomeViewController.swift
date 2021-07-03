//
//  HomeViewController.swift
//  MovieApp
//
//  Created by Ahmed Fayek on 6/30/21.
//

import UIKit
import SDWebImage
import CoreData

class HomeViewController: UIViewController {
    
    var moviesArray: Array<Movie>?
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getMovies()
        //saveToCoreData()
        //fetchFromCoreData()
        //deleteFromCoreData()
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
                    movieObject.relaseYear = rawMovie["releaseYear"] as? Int
                    
                    self.moviesArray?.append(movieObject)
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                for movie in self.moviesArray! {
                    print(movie.title)
                }
            }catch{
                print("error \(error)")
            }
        }.resume()
    }
    
    
    func saveToCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context     = appDelegate.persistentContainer.viewContext
        let entity      = NSEntityDescription.entity(forEntityName: "Movies", in: context)
        let movie       = NSManagedObject(entity: entity!, insertInto: context)
        
        movie.setValue("Zombie", forKey: "title")
        movie.setValue(7, forKey: "rate")
        movie.setValue(2009, forKey: "releaseYear")
        
        do{
            try context.save()
            print("data saved successfully")
        }catch{
            print("error saving")
        }
    }
    
    func fetchFromCoreData(){
        let appDelegate     = UIApplication.shared.delegate as! AppDelegate
        let context         = appDelegate.persistentContainer.viewContext
        let fetchRequest    = NSFetchRequest<NSManagedObject>(entityName: "Movies")
        
        //fetch with conditions -> Predicates
//        let predicate       = NSPredicate(format: "title == %@", "Iron man")
//        fetchRequest.predicate  = predicate
        
        do{
            let movies      = try context.fetch(fetchRequest)
            for movie in movies{
                print("title: \(movie.value(forKey: "title"))")
            }
        }catch{
            print("error fetching data")
        }
    }
    
    func deleteFromCoreData(){
        let appDelegate         = UIApplication.shared.delegate as! AppDelegate
        let context             = appDelegate.persistentContainer.viewContext
        let fethcRequest        = NSFetchRequest<NSManagedObject>(entityName: "Movies")
        let predicate           = NSPredicate(format: "title == %@", "Iron man")
        fethcRequest.predicate  = predicate
        do{
            let movies          = try context.fetch(fethcRequest)
            context.delete(movies[0])
            try context.save()
        }catch{
            print("error deleting")
        }
    }
    
}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count \(moviesArray?.count ?? 0)")
        return moviesArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath)as! MovieCollectionViewCell
        cell.titleLabel.text = moviesArray?[indexPath.row].title
        cell.imageView.sd_setImage(with: URL(string: (moviesArray?[indexPath.row].image)!), completed: nil)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "detailsVC") as! DetailsViewController
        detailsVC.movie = moviesArray?[indexPath.row]
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
