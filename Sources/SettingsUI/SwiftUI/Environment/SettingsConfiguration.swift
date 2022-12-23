//
//  SettingsConfiguration.swift
//  
//
//  Created by Kamaal M Farah on 20/12/2022.
//

import SwiftUI
import ShrimpExtensions

public struct SettingsConfiguration: Hashable {
    public let donations: [StoreKitDonation]
    public let feedback: FeedbackConfiguration?
    public let color: ColorsConfiguration?
    public let features: [Feature]
    var isDefault = false

    public init(
        donations: [StoreKitDonation] = [],
        feedback: FeedbackConfiguration? = nil,
        color: ColorsConfiguration? = nil,
        features: [Feature] = []) {
            self.donations = donations
            self.feedback = feedback
            self.color = color
            self.features = features
        }

    private init(isDefault: Bool) {
        self.init()
        self.isDefault = isDefault
    }

    var donationsIsConfigured: Bool {
        !donations.isEmpty
    }

    var feedbackIsConfigured: Bool {
        feedback != nil
    }

    var colorsIsConfigured: Bool {
        guard let color else { return false }

        return !color.colors.isEmpty && color.colors.find(where: { $0 == color.currentColor }) != nil
    }

    var featuresIsConfigured: Bool {
        !features.isEmpty
    }

    var acknowledgementsAreConfigured: Bool {
        true
    }

    var currentColor: Color {
        color?.currentColor.color ?? .accentColor
    }

    public struct FeedbackConfiguration: Hashable {
        public let token: String
        public let username: String
        public let repoName: String
        public let additionalLabels: [String]
        public let additionalData: Data?

        public init(
            token: String,
            username: String,
            repoName: String,
            additionalLabels: [String] = [],
            additionalData: Data? = nil) {
                self.token = token
                self.username = username
                self.repoName = repoName
                self.additionalLabels = additionalLabels
                self.additionalData = additionalData
            }

        var additionalDataString: String? {
            guard let additionalData else { return nil }

            return String(data: additionalData, encoding: .utf8)
        }
    }

    public struct ColorsConfiguration: Hashable {
        public let colors: [AppColor]
        public let currentColor: AppColor

        public init(colors: [AppColor], currentColor: AppColor) {
            self.colors = colors
            self.currentColor = currentColor
        }
    }

    static let `default` = SettingsConfiguration(isDefault: true)
}

extension EnvironmentValues {
    var settingsConfiguration: SettingsConfiguration {
        get { self[SettingsConfigurationKey.self] }
        set { self[SettingsConfigurationKey.self] = newValue }
    }
}

struct SettingsConfigurationKey: EnvironmentKey {
    static let defaultValue: SettingsConfiguration = .default
}
