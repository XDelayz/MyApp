# Импортируем класс Flask и функцию request из модуля flask
# Импортируем модуль subprocess для вызова внешних программ
from flask import Flask, request
import subprocess

# Создаем экземпляр Flask-приложения
app = Flask(__name__)

# Создаем маршрут для главной страницы
@app.route('/')
def home():
    # Возвращаем HTML-страницу с формой для заполнения
    return '''
        <form method="POST" action="/run_script">
            <label for="os_username">OS_USERNAME:</label>
            <input type="text" id="os_username" name="os_username"><br><br>
            <label for="volume_id">Volume ID3:</label>
            <input type="text" id="volume_id" name="volume_id"><br><br>
            <label for="new_size">New size:</label>
            <input type="text" id="new_size" name="new_size"><br><br>
            <label for="project_id">Project ID:</label>
            <input type="text" id="project_id" name="project_id"><br><br>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password"><br><br>
            <input type="submit" value="Submit">
        </form>
    '''

# Создаем маршрут для обработки POST-запросов на адрес '/run_script'
@app.route('/run_script', methods=['POST'])
def run_script():
    # Получаем значение volume_id из формы
    volume_id = request.form['volume_id']
    # Получаем значение new_size из формы
    new_size = request.form['new_size']
    # Получаем значение project_id из формы
    project_id = request.form['project_id']
    # Получаем значение password из формы
    password = request.form['password']
    os_username = request.form['os_username']


    # Записываем значение volume_id в файл 'fileid.txt'
    with open('fileid.txt', 'w') as f:
        f.write(volume_id)
    # Записываем значение new_size в файл 'filesize.txt'
    with open('filesize.txt', 'w') as f:
        f.write(new_size)

    with open('fileprojectid.txt', 'w') as f:
        f.write(project_id)
    with open('filepassword.txt', 'w') as f:
        f.write(password)
    with open('os_username.txt', 'w') as f:
        f.write(os_username)
    
    # Вызываем скрипт на языке Bash, передавая ему путь к файлу 'script.sh'
    subprocess.call(['bash','./script.sh'])

    # Возвращаем сообщение об успешном выполнении скрипта
    return 'Script has been executed.'

# Если код запускается как основной скрипт, запускаем Flask-приложение
if __name__ == '__main__':
    # Запускаем приложение в режиме отладки
    app.run()



