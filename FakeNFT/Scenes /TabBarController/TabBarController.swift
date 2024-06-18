import UIKit

final class TabBarController: UITabBarController {

    var servicesAssembly: ServicesAssembly?

    private let statisticsTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.statistics", comment: ""),
        image: UIImage(systemName: "flag.2.crossed.fill"),
        tag: 3
    )

    private let profileTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.profile", comment: ""),
        image: UIImage(systemName: "person.crop.circle.fill"),
        tag: 0
    )

    private let catalogTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.catalog", comment: ""),
        image: UIImage(systemName: "square.stack.3d.up.fill"),
        tag: 1
    )

    private let cartTabBarItem = UITabBarItem(
        title: NSLocalizedString("Tab.cart", comment: ""),
        image: UIImage(named: "cart"),
        tag: 2
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let servicesAssembly else {
            return
        }

        let statisticsAsssembly = StatisticsAssembly(servicesAssembler: servicesAssembly)
        let statisticsController = UINavigationController(rootViewController: statisticsAsssembly.build())
        statisticsController.tabBarItem = statisticsTabBarItem

        let presenter = ProfilePresenterImpl(
            profileService: servicesAssembly.profileService,
            nftService: servicesAssembly.nftService
        )

        let viewController = ProfileViewController(presenter: presenter)
        presenter.view = viewController
        let profileController = UINavigationController(rootViewController: viewController)
        profileController.tabBarItem = profileTabBarItem

        let catalogController = TestCatalogViewController(
            servicesAssembly: servicesAssembly
        )

        let cartController = CartViewController(servicesAssembly: servicesAssembly)
        catalogController.tabBarItem = catalogTabBarItem
        cartController.tabBarItem = cartTabBarItem

        let cartNavigationController = UINavigationController(rootViewController: cartController)

        viewControllers = [profileController, catalogController, cartNavigationController, statisticsController]
        view.backgroundColor = .background
        selectedIndex = 0
        view.tintColor = UIColor.segmentActive

    }

    func hideTabBar() {
        view.removeFromSuperview()
    }
}
