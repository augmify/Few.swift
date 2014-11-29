//
//  Label.swift
//  Few
//
//  Created by Josh Abernathy on 8/5/14.
//  Copyright (c) 2014 Josh Abernathy. All rights reserved.
//

import Foundation
import AppKit

private let DefaultLabelFont = NSFont.labelFontOfSize(NSFont.systemFontSizeForControlSize(.RegularControlSize))
private let LabelFudge = CGSize(width: 4, height: 0)

public class Label: Element {
	private let attributedString: NSAttributedString

	public convenience init(text: String) {
		let attributedString = NSAttributedString(string: text, attributes: [NSFontAttributeName: DefaultLabelFont])
		self.init(attributedString: attributedString)
	}

	public init(attributedString: NSAttributedString) {
		self.attributedString = attributedString
		super.init()

		let capSize = CGSize(width: 1000, height: 1000)
		let rect = self.attributedString.boundingRectWithSize(capSize, options: .UsesLineFragmentOrigin | .UsesFontLeading)
		self.frame.size = CGSize(width: ceil(rect.size.width) + LabelFudge.width, height: ceil(rect.size.height) + LabelFudge.height)
	}

	// MARK: Element

	public override func applyDiff(view: ViewType, other: Element) {
		let otherLabel = other as Label
		let textField = view as NSTextField

		if attributedString != textField.attributedStringValue {
			textField.attributedStringValue = attributedString
		}

		super.applyDiff(view, other: other)
	}

	public override func realize() -> ViewType? {
		let field = NSTextField(frame: frame)
		field.editable = false
		field.drawsBackground = false
		field.bordered = false
		field.font = DefaultLabelFont
		field.attributedStringValue = attributedString
		return field
	}
}

//public protocol El {
//	var key: String? { get }
//	var frame: CGRect { get set }
//
//	func canDiff(other: El) -> Bool
//	func applyDiff(view: ViewType, other: El)
//	func realize() -> ViewType?
//	func derealize()
//	func getChildren() -> [El]
//}

struct LabelTNG: El {
	var key: String?
	var frame: CGRect

	private let attributedString: NSAttributedString

	func canDiff(other: El) -> Bool {
		return other is LabelTNG
	}

	func applyDiff(view: ViewType, other: El) {
		let otherLabel = unsafeBitCast(other, LabelTNG.self) // other as LabelTNG
		let textField = view as NSTextField

		if attributedString != textField.attributedStringValue {
			textField.attributedStringValue = attributedString
		}
	}

	func realize() -> ViewType? {
		let field = NSTextField(frame: frame)
		field.editable = false
		field.drawsBackground = false
		field.bordered = false
		field.font = DefaultLabelFont
		field.attributedStringValue = attributedString
		return field
	}

	func derealize() {}

	func getChildren() -> [El] {
		return []
	}
}
