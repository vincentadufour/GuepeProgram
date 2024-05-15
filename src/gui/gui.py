import sys
from PyQt5.QtWidgets import QApplication, QWidget, QPushButton, QVBoxLayout

class MainWindow(QWidget):
    def __init__(self):
        super().__init__()
        
        self.initUI()
    
    def initUI(self):
        # Create a button
        self.button = QPushButton('Click Me but Longer, Much Longer', self)
        
        # Connect the button's click event to a method
        self.button.clicked.connect(self.on_button_click)
        
        # Create a layout and add the button
        layout = QVBoxLayout()
        layout.addWidget(self.button)
        
        # Set the layout on the application's window
        self.setLayout(layout)
        
        self.setWindowTitle('PyQT5')
        self.showMaximized()
        self.show()
    
    def on_button_click(self):
        print('Button clicked!')

if __name__ == '__main__':
    app = QApplication(sys.argv)
    mainWin = MainWindow()
    sys.exit(app.exec_())
