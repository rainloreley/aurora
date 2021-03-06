//
// Aurora
// File created by Lea Baumgart on 27.03.21.
//
// Licensed under the MIT License
// Copyright © 2021 Lea Baumgart. All rights reserved.
//
// https://git.abmgrt.dev/exc_bad_access/aurora
//

import SwiftUI

struct ProjectFloatingIPDetailView: View {
    @ObservedObject var controller: ProjectFloatingIPDetailController

    var body: some View {
        ScrollView {
            Group {
                Group {
                    HStack(alignment: .top) {
                        Spacer()
                        VStack(alignment: .trailing) {
                            if controller.floatingip.protection.delete {
                                HStack {
                                    Text("Locked").foregroundColor(.gray).italic()
                                    Image(systemName: "lock").foregroundColor(.gray)
                                }
                            }
                            if controller.floatingip.server != nil {
                                HStack {
                                    Text("Assigned to: ") + Text("\(controller.project.servers.first(where: { $0.id == controller.floatingip.server! })?.name ?? "unknown")").bold()
                                    Image(systemName: "checkmark.circle").foregroundColor(.green)
                                }
                            } else {
                                HStack {
                                    Text("Unassigned").foregroundColor(.gray).italic()
                                    Image(systemName: "xmark.circle").foregroundColor(.red)
                                }
                            }

                            if controller.floatingip.blocked {
                                HStack {
                                    Text("Blocked").foregroundColor(.red)
                                    Image(systemName: "hand.raised").foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 350), alignment: .top)], alignment: .center, spacing: 10, pinnedViews: []) {
                    FloatingCardBackgroundView {
                        VStack {
                            HStack {
                                Text("Configuration").bold().font(.title3)
                                Spacer()
                            }.padding(.bottom)
                            HStack(alignment: .top) {
                                Image(systemName: "network").frame(width: 20)
                                Text("IP: ") + Text("\(controller.floatingip.ip)").bold()
                                Spacer()
                            }
                            HStack(alignment: .top) {
                                Image(systemName: "gearshape.2").frame(width: 20)
                                Text("Type: ") + Text("\(controller.floatingip.type.getHumanName())").bold()
                                Spacer()
                            }
                            ForEach(controller.floatingip.dns_ptr, id: \.ip) { dnsptr in
                                HStack(alignment: .top) {
                                    Image(systemName: "number").frame(width: 20)
                                    Text("Reverse DNS (\(dnsptr.ip)): ") + Text("\(dnsptr.dns_ptr)").bold()
                                    Spacer()
                                }
                            }
                        }
                    }

                    FloatingCardBackgroundView {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Location").bold().font(.title3)
                                Spacer()
                            }.padding(.bottom)

                            Text("City: ") + Text("\(controller.floatingip.home_location.city)").bold()
                            Text("Datacenter: ") + Text("\(controller.floatingip.home_location.description)").bold()
                            Text("Country: ") + Text("\(controller.floatingip.home_location.country)").bold()
                        }
                    }
                }.padding([.top, .bottom])
            }.padding()
        }.navigationBarTitle(Text("\(controller.floatingip.name)"))
    }
}

class ProjectFloatingIPDetailController: ObservableObject {
    @Published var project: CloudProject
    @Published var floatingip: CloudFloatingIP

    init(project: CloudProject, floatingip: CloudFloatingIP) {
        self.project = project
        self.floatingip = floatingip
    }
}
