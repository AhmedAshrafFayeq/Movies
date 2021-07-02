//
//  DetailsViewController.swift
//  MovieApp
//
//  Created by Ahmed Fayek on 6/30/21.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var movie: Movie?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseYearLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        imageView.sd_setImage(with: URL(string: (movie?.image)!), completed: nil)
        titleLabel.text     = movie?.title
        ratingLabel.text    = "\(movie?.rating)"
        releaseYearLabel.text   = "\(movie?.relaseYear)"
        
    }
    

}
