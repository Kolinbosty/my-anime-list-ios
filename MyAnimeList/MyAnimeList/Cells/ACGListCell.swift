//
//  ACGListCell.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/12.
//

import UIKit
import Combine
import Kingfisher

class ACGListCell: UITableViewCell {

    private weak var photoView: UIImageView!
    private weak var vStack: UIStackView!
    private weak var rankLabel: UILabel!
    private weak var titleLabel: UILabel!
    private weak var periodLabel: UILabel!
    private weak var heartButton: UIButton!

    private var viewModel: ACGListCellBindable?

    private var vmCancellables: Set<AnyCancellable> = .init()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Setup
        selectionStyle = .none
        setupUI()
    }

    func binding(with viewModel: ACGListCellBindable) {
        // Reset
        vmCancellables.removeAll()
        self.viewModel = viewModel

        viewModel.listPhotoURL
            .sink { [weak self] url in
                self?.photoView.kf.setImage(with: url)
            }
            .store(in: &vmCancellables)

        viewModel.listTitle
            .assign(to: \.text, on: titleLabel)
            .store(in: &vmCancellables)

        viewModel.listRankText
            .assign(to: \.text, on: rankLabel)
            .store(in: &vmCancellables)

        viewModel.listPeriodText
            .assign(to: \.text, on: periodLabel)
            .store(in: &vmCancellables)

        viewModel.listHeartIcon
            .sink { [weak self] icon in
                self?.heartButton.setImage(icon, for: .normal)
            }
            .store(in: &vmCancellables)
    }
}

// MARK: - Action
private extension ACGListCell {
    @objc func handleHeartTapped() {
        viewModel?.handleHeartTapped()
    }
}

// MARK: - Create UI
extension ACGListCell {
    private func setupUI() {
        // Create
        createPhotoView()
        createVStack()
        createRankLabel()
        createTitleLabel()
        createPeriodLabel()
        createHeartButton()

        // Layout
        setupConstraint()
    }

    private func createPhotoView() {
        guard photoView == nil else {
            assert(false, "Error: Already Created!")
            return
        }

        // Create
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true

        // Add
        contentView.addSubview(imgView)
        photoView = imgView
    }

    private func createVStack() {
        guard vStack == nil else {
            assert(false, "Error: Already Created!")
            return
        }

        // Create
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 8.0

        // Add
        contentView.addSubview(stackView)
        vStack = stackView
    }

    private func createRankLabel() {
        guard rankLabel == nil else {
            assert(false, "Error: Already Created!")
            return
        }

        // Create
        let label = UILabel()

        // Add
        vStack.addArrangedSubview(label)
        rankLabel = label
    }

    private func createTitleLabel() {
        guard titleLabel == nil else {
            assert(false, "Error: Already Created!")
            return
        }

        // Create
        let label = UILabel()
        label.numberOfLines = 3

        // Add
        vStack.addArrangedSubview(label)
        titleLabel = label
    }

    private func createPeriodLabel() {
        guard periodLabel == nil else {
            assert(false, "Error: Already Created!")
            return
        }

        // Create
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12.0)
        label.textColor = .lightGray

        // Add
        vStack.addArrangedSubview(label)
        periodLabel = label
    }

    private func createHeartButton() {
        guard heartButton == nil else {
            assert(false, "Error: Already Created!")
            return
        }

        // Create
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.sf_heart_fill, for: .normal)
        button.addTarget(self, action: #selector(handleHeartTapped), for: .touchUpInside)

        // Add
        contentView.addSubview(button)
        heartButton = button
    }

    private func setupConstraint() {
        let photoHConstraint = photoView.heightAnchor.constraint(equalToConstant: 150.0)
        photoHConstraint.priority = .required - 1

        NSLayoutConstraint.activate([
            // Photo
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                           constant: 4.0),
            photoView.leftAnchor.constraint(equalTo: contentView.leftAnchor,
                                            constant: 16.0),
            photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                              constant: -4.0),
            photoHConstraint,
            photoView.widthAnchor.constraint(equalTo: photoView.heightAnchor,
                                             multiplier: 133.0 / 207.0),
            // Stack
            vStack.topAnchor.constraint(equalTo: photoView.topAnchor),
            vStack.leftAnchor.constraint(equalTo: photoView.rightAnchor,
                                         constant: 8.0),
            vStack.bottomAnchor.constraint(equalTo: photoView.bottomAnchor),
            vStack.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                          constant: -16.0),
            // Heart
            heartButton.topAnchor.constraint(equalTo: contentView.topAnchor,
                                             constant: 4.0),
            heartButton.rightAnchor.constraint(equalTo: contentView.rightAnchor,
                                               constant: -8.0)
        ])
    }
}
