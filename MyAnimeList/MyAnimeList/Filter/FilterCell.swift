//
//  FilterCell.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/11.
//

import UIKit
import Combine

class FilterCell: UITableViewCell {
    private weak var hStack: UIStackView!
    private weak var selectionIconView: UIImageView!
    private weak var filterNameLabel: UILabel!

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

    func binding(with viewModel: FilterCellViewModel) {
        // Clean
        vmCancellables.removeAll()

        // Text
        viewModel.$name
            .map { $0 as String? }
            .assign(to: \.text, on: filterNameLabel)
            .store(in: &vmCancellables)

        // Icon
        viewModel.iconPublisher
            .assign(to: \.image, on: selectionIconView)
            .store(in: &vmCancellables)
    }
}

extension FilterCell {
    private func setupUI() {
        // Create
        createHStack()
        createIconView()
        createFilterNameLabel()

        // Layout
        setupConstraint()
    }

    private func createHStack() {
        guard hStack == nil else {
            assert(false, "Error: Already Created!")
            return
        }

        // Create
        let stackView = UIStackView(frame: contentView.bounds)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 8.0, left: 16.0, bottom: 8.0, right: 16.0)

        // Add
        contentView.addSubview(stackView)
        hStack = stackView
    }

    private func createIconView() {
        guard selectionIconView == nil else {
            assert(false, "Error: Already Created!")
            return
        }

        // Create
        let imgView = UIImageView()
        imgView.image = .sf_circle

        // Add
        hStack.addArrangedSubview(imgView)
        selectionIconView = imgView
    }

    private func createFilterNameLabel() {
        guard filterNameLabel == nil else {
            assert(false, "Error: Already Created!")
            return
        }

        // Create
        let label = UILabel()

        // Add
        hStack.addArrangedSubview(label)
        filterNameLabel = label
    }

    private func setupConstraint() {
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            hStack.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            hStack.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor),
        ])
    }
}
