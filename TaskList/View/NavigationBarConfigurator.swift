//
//  NavigationBarConfigurator.swift
//  TaskList
//
//  Created by Artem H on 12/18/24.
//

import UIKit

struct NavigationBarConfigurator {
    
    static func setupNavigationBar(for viewController: UIViewController, title: String, addAction: Selector) {
        
        let vc = viewController.navigationController
        
        viewController.title = title
        
        vc?.navigationBar.prefersLargeTitles = true
        
        // Navigation bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        
        navBarAppearance.backgroundColor = .milkBlue
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        vc?.navigationBar.standardAppearance = navBarAppearance
        vc?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        // Add button to navigation bar
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: addAction
        )
        
        vc?.navigationBar.tintColor = .white
    }
}
