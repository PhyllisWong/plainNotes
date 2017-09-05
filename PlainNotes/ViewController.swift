//
//  ViewController.swift
//  PlainNotes
//
//  Created by djchai on 8/30/17.
//  Copyright © 2017 Phyllis Wong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	@IBOutlet weak var table: UITableView!
	var data: [String] = []
	var selectedRow:Int = -1
	var newRowText:String = ""
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Notes"
		let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
		self.navigationItem.rightBarButtonItem = addButton
		self.navigationItem.leftBarButtonItem = editButtonItem
		load()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if selectedRow == -1 {
			return
		}
		data[selectedRow] = newRowText
		if newRowText == "" {
			data.remove(at: selectedRow)
		}
		table.reloadData()
		save()
	}
	
	@objc func addNote() {
		let name:String = "type new note here"
		data.insert(name, at: 0)
		let indexPath:IndexPath = IndexPath(row: 0, section: 0)
		table.insertRows(at: [indexPath], with: .automatic)
		table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
		self.performSegue(withIdentifier: "detail", sender: nil)
		
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		print("\(data[indexPath.row])")
		self.performSegue(withIdentifier: "detail", sender: nil)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let detailView:DetailViewController = segue.destination as! DetailViewController
		selectedRow = table.indexPathForSelectedRow!.row
		detailView.masterView = self
		detailView.setText(t: data[selectedRow])
		
	}
	
	func save() {
		UserDefaults.standard.set(data, forKey: "notes")
		UserDefaults.standard.synchronize()
	}
	
	func load() {
		if let loadedData = UserDefaults.standard.value(forKey: "notes") as? [String] {
			data = loadedData
			table.reloadData()
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
		cell.textLabel?.text = data[indexPath.row]
		return cell
	}
	
	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)
		table.setEditing(editing, animated: animated)
	}

	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		data.remove(at: indexPath.row)
		table.deleteRows(at: [indexPath], with: .fade)
		save()
	}
	
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

