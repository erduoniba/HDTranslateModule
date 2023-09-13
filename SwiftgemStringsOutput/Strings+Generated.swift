// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum InfoPlist {
    /// HDTranslate
    internal static let cfBundleDisplayName = L10n.tr("InfoPlist", "CFBundleDisplayName", fallback: "HDTranslate")
    /// Needs access to your camera to take you to experience code scanning, shooting, red envelope scanning, reality shopping, etc
    internal static let nsPhotoLibraryUsageDescription = L10n.tr("InfoPlist", "NSPhotoLibraryUsageDescription", fallback: "Needs access to your camera to take you to experience code scanning, shooting, red envelope scanning, reality shopping, etc")
  }
  internal enum LaunchScreen {
    internal enum Ev1CzGJn {
      /// I am English LaunchScreen
      internal static let text = L10n.tr("LaunchScreen", "Ev1-cz-gJn.text", fallback: "I am English LaunchScreen")
    }
  }
  internal enum Localizabless {
    /// good
    internal static let good = L10n.tr("Localizabless", "good", fallback: "good")
    /// Localizable.strings
    ///   HDTranslateModule
    /// 
    ///   Created by denglibing on 2023/8/16.
    ///   Copyright © 2023 denglibing5. All rights reserved.
    internal static let hello = L10n.tr("Localizabless", "hello", fallback: "hello")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
