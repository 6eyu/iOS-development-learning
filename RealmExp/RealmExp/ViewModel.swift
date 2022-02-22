//
//  ViewModel.swift
//  RealmExp
//
//  Created by vliu on 21/2/2022.
//

import Foundation

class ProjectListViewModel: ObservableObject {
    @Published var projects: [Project] = []
    
    func addProject() {
        self.projects.append(Project())
    }
    
}
