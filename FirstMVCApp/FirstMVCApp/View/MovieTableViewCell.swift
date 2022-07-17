//
//  MovieTableViewCell.swift
//  FirstMVCApp
//
//  Created by iAskedYou2nd on 7/14/22.
//

import UIKit


protocol MovieCellErrorDelegate: AnyObject {
    func initiateErrorMsg(err: NetworkError)
}

class MovieTableViewCell: UITableViewCell {

    static let reuseId = "\(MovieTableViewCell.self)"
    
    // FIXME: Fix constraint for imageView and to show all overview text
    lazy var movieImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemPink
        imageView.image = UIImage(named: "Sample")
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        return imageView
    }()
    
    lazy var titleLabel: PaddingLabel = {
        let label = PaddingLabel(padding: 2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.layer.cornerRadius = 10.0
        label.layer.masksToBounds = true
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.text = "Movie Title"
        label.backgroundColor = .systemOrange
        return label
    }()
    
    lazy var overviewLabel: PaddingLabel = {
        let label = PaddingLabel(padding: 2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.layer.cornerRadius = 10.0
        label.layer.masksToBounds = true
        label.text = "Movie Description"
        label.backgroundColor = .systemPurple
        return label
    }()
    
    var delegate: MovieCellErrorDelegate?
    var movie: Movie?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Solution here is to place 2 inner stackviews 
    private func setUpUI() {
        
        let hStack = UIStackView(axis: .horizontal, spacing: 8, distribution: .fill)
        let vStackRight = UIStackView(axis: .vertical, spacing: 8, distribution: .fill)
        let vStackLeft = UIStackView(axis: .vertical, spacing: 8, distribution: .fill)
        
        let rightBufferTop = UIView.createBufferView()
        let rightBufferBottom = UIView.createBufferView()
        
        vStackRight.addArrangedSubview(rightBufferTop)
        vStackRight.addArrangedSubview(self.titleLabel)
        vStackRight.addArrangedSubview(self.overviewLabel)
        vStackRight.addArrangedSubview(rightBufferBottom)
        
        rightBufferTop.heightAnchor.constraint(equalTo: rightBufferBottom.heightAnchor).isActive = true
        
        
        let leftBufferTop = UIView.createBufferView()
        let leftBufferBottom = UIView.createBufferView()
        
        vStackLeft.addArrangedSubview(leftBufferTop)
        vStackLeft.addArrangedSubview(self.movieImageView)
        vStackLeft.addArrangedSubview(leftBufferBottom)
        
        leftBufferTop.heightAnchor.constraint(equalTo: leftBufferBottom.heightAnchor).isActive = true
        
        hStack.addArrangedSubview(vStackLeft)
        hStack.addArrangedSubview(vStackRight)
        
        self.contentView.addSubview(hStack)
        
        hStack.bindToSuperView()
    }
    
    func configure(movie: Movie, network: NetworkManager) {
        
        self.movie = movie
        
        self.titleLabel.text = movie.title
        self.overviewLabel.text = movie.overview
        
        
        if let imageData = ImageCache.shared.getImageData(key: movie.posterPath) {
            print("Image found in cache")
            self.movieImageView.image = UIImage(data: imageData)
            return
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            network.fetchImageData(urlStr: "https://image.tmdb.org/t/p/w500\(movie.posterPath)") { result in
                switch result {
                case .success(let imageData):
                    DispatchQueue.main.async {
                        print("Image pulled from network")
                        ImageCache.shared.setImageData(data: imageData, key: movie.posterPath)
                        
                        if movie.id == (self.movie?.id ?? -1) {
                            self.movieImageView.image = UIImage(data: imageData)
                        }
                    }
                case .failure(let error):
                    print(error)
                    self.delegate?.initiateErrorMsg(err: error)
                }
            }
        }
        
    }
    
    
    override func prepareForReuse() {
        self.titleLabel.text = "Movie Title"
        self.overviewLabel.text = "Movie Description"
        self.movieImageView.image = UIImage(named: "Sample")
        self.movie = nil
    }

}
