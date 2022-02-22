//
//  ContentView.swift
//  RealmExp
//
//  Created by vliu on 21/2/2022.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    
    var body: some View {
        
        NavigationView {
            TabView {
                ProjectList()
                    .tabItem {
                        Image(systemName: "house.circle.fill")
                        Text("Projects")
                    }
                
                Color.green
                    .tabItem {
                        Image(systemName: "gearshape.circle.fill")
                        Text("Settings")
                    }
            }
        }
    }
}


struct ProjectList: View {
    
//    @ObservedResults(Project.self) var projects
    
    @ObservedObject var vm: ProjectListViewModel = ProjectListViewModel()
    
    var body: some View {
        VStack {
            Text("Project List")
            
            List(vm.projects) { project in
                ProjectCard(project: project)
            }
            
            Button {
//                $projects.append(Project())
                vm.addProject()
            } label: {
                Text("Add Project")
            }
            
        }
    }
}

struct ProjectCard: View {
    @ObservedObject var project: Project

    var body: some View {
        NavigationLink(destination: ReferenceView(project: project)) {
            Text(project.reference)
        }
    }
}

struct ReferenceView: View {
    @ObservedObject var project: Project
    
    var body: some View {
        TextField("Reference", text: $project.reference)
    }
}

// MARK: Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ReferenceView_Previews: PreviewProvider {
    static var previews: some View {
        ShowReferenceView()
    }
}

struct ShowReferenceView: View {
    @State var project: Project = Project()
    
    var body: some View {

        ReferenceView(project: project)

    }
}

