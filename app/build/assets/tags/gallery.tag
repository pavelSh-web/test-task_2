<gallery class="gallery animate__fadeInUp">
    <div class="container">
        <div class="gallery-inner">
            <div class="gallery-column" each={column in gallery}>
                <div class="gallery-item gallery-item_{size}" style="background: {color}" each={column}>
                    <img class="b-lazy" data-src={src} alt="">
                </div>
            </div>
        </div>
    </div>
    <script>

        //Стартовый шаблон основной сетки
        let resultObj = {};
        if (document.body.clientWidth <= 600) {
            resultObj = {
                gallery: [[]]
            }
        } else {
            resultObj = {
                gallery: [[], [], []]
            }
        }
        this.gallery = resultObj.gallery;

        const tagElem = this.root;
        //url запроса
        let clientId = 'fVktfCz87cJUOPqt1n8TE2LVqWNRpCNIupj9frxQsiY';
        const query = ['drone view', 'sea', 'summer', 'nature', 'sky', 'mountain', 'travel', 'tourism', 'lake'];
        let url = 'https://api.unsplash.com/search/photos/?client_id=' +
        clientId + '&query='; 

        //Добавление класса, отменяющего 'position: fixed' у элемента .photo-head
        if (screen.height <= 550) {
            document.querySelector('.photo-head').classList.add('unfixed');
        }

        //Функция изменений при повороте тач-устройства
        const doOnOrientationChange = () => {
            const results = [];
            if (window.orientation == -90 || window.orientation == 90) {
                if (screen.height <= 550) {
                    document.querySelector('.photo-head').classList.add('unfixed');
                }
                if (screen.width > 600) {
                    const j = resultObj.gallery[0].length / 3;
                    for (let i = 0; i < resultObj.gallery[0].length; i += j)
                        results.push(resultObj.gallery[0].slice(i, i + j));
                    resultObj.gallery = results;
                } else {
                    document.querySelector('.photo-head').classList.remove('unfixed');
                }
            } else {
                document.querySelector('.photo-head').classList.remove('unfixed');
                if (screen.width <= 600) {
                    resultObj.gallery.forEach(arr => {
                        arr.forEach(item => {
                            results.push(item)
                        })
                    });
                    resultObj.gallery = [];
                    resultObj.gallery[0] = results;
                }
            }
            this.gallery = resultObj.gallery;
            new Blazy({
                offset: -200
            });
            riot.update();
        }
        window.addEventListener('orientationchange', doOnOrientationChange);
        


        //Функция запрашивает фотографии и формирует их в сетку
        const getPhoto = (url) => {
            //Шаблон сетки
            let gridArr = [
                [{ size: "xs" }, { size: "s" }, { size: "l" }],
                [{ size: "s" }, { size: "l" }, { size: "xs" }],
                [{ size: "l" }, { size: "xs" }, { size: "s" }],
            ];

            //Рандомный url
            url += query[Math.floor(Math.random() * query.length)];
            
            //Запускаем лоадер
            tagElem.classList.add('loading');

            
            fetch(url)  
                .then((response) => {
                    
                    if (response.status !== 200) {  
                        console.log('Looks like there was a problem. Status Code: ' +  
                        response.status);  
                        return;  
                    }

                    response.json().then((data) => {
                        //Счетчик для фотографий
                        let count = 0;

                        //Массив для предварительного заполнения
                        let fillGrid = [];

                        if (document.body.clientWidth <= 600) {

                            resultObj.gallery.forEach(gridCol => {
                                for ( let i = 0; i < 3; i++) {
                                    //Рандомный индекс для gridArr
                                    const randomI = Math.floor(Math.random() * gridArr.length);
                                    //Заполнение каждого элемента столбца
                                    for( let j = 0; j < 3; j++ ) {
                                        gridArr[randomI][j].src = data.results[count].urls.regular;
                                        gridArr[randomI][j].color = data.results[count].color;
                                        count++
                                    }
                                    fillGrid = fillGrid.concat(gridArr[randomI]);
                                    gridArr.splice(randomI, 1);
                                }

                                //Заполняем текущую колонку
                                fillGrid.forEach((item) => {
                                    gridCol.push(item);
                                });
                            });
                           
                        } else {

                            resultObj.gallery.forEach((gridCol) => {
                                //Рандомный столбец сетки
                                const randomI = Math.floor(Math.random() * gridArr.length)
                                
                                fillGrid = gridArr[randomI];
                                gridArr.splice(randomI, 1);

                                //Заполнение каждого элемента столбца
                                for( let j = 0; j < 3; j++ ) {
                                    fillGrid[j].src = data.results[count].urls.regular;
                                    fillGrid[j].color = data.results[count].color;
                                    count++
                                }

                                //Заполняем колонку
                                fillGrid.forEach((item) => {
                                    gridCol.push(item);
                                });
                            });
                            
                        }
                    
                        riot.update();
                        
                        //Отключаем лоадер
                        tagElem.classList.remove('loading');
                        //Запускаем ленивую загрузку
                        new Blazy({
                            offset: -200
                        });
                    });  
                })
                .catch((err) => {  
                    console.log('Fetch Error :-S', err);  
                });
        }
        getPhoto(url);

        //Функция добавляет верхний отступ у gallery
        function addMargin() {
            function elementSize(selector) {
                const element = document.querySelector(selector);
                return element.clientHeight;
            }
            document.querySelector('gallery').style.marginTop = elementSize('.photo-head') + 'px';
        }
        addMargin();
        window.addEventListener('resize', () => addMargin())



        //Отслеживание конца страницы и отправка нового запроса
        window.addEventListener('scroll',() => {
            const clientHeight = document.documentElement.clientHeight ? document.documentElement.clientHeight : document.body.clientHeight;
            const documentHeight = document.documentElement.scrollHeight ? document.documentElement.scrollHeight : document.body.scrollHeight;
            const scrollTop = window.pageYOffset ? window.pageYOffset : (document.documentElement.scrollTop ? document.documentElement.scrollTop : document.body.scrollTop);

            if((documentHeight - clientHeight) <= scrollTop) {
                getPhoto(url);
            }
        });
    </script>
</gallery>
