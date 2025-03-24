//
//  resources.swift
//  LionWell real
//
//  Created by Adheera Chilamkurthi on 2/24/25.
//
import SwiftUI

struct ResourcesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ResourceSection(
                    title: "University Health Services (UHS)",
                    website: "studentaffairs.psu.edu/health",
                    phone: "814-865-4UHS (4847)"
                )
                
                ResourceSection(
                    title: "Health Promotion & Wellness",
                    website: "studentaffairs.psu.edu/health-promotion",
                    phone: "814-863-0461"
                )
                
                ResourceSection(
                    title: "Counseling & Psychological Services (CAPS)",
                    website: "studentaffairs.psu.edu/counseling",
                    phone: "814-863-0395"
                )
                
                ResourceSection(
                    title: "Crisis Services (24/7)",
                    phone: "877-229-6400"
                )
                
                ResourceSection(
                    title: "Crisis Text Line",
                    description: "Text \"LIONS\" to 741741"
                )
                
                ResourceSection(
                    title: "Campus Recreation",
                    website: "studentaffairs.psu.edu/campusrec",
                    phone: "814-867-1600"
                )
                
                ResourceSection(
                    title: "Penn State Learning",
                    website: "pennstatelearning.psu.edu/",
                    phone: "814-865-2582"
                )
            }
            .padding()
        }
        .navigationTitle("Resources")
    }
}

struct ResourcesView_Previews: PreviewProvider {
    static var previews: some View {
        ResourcesView()
    }
}

     
              
